import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'kid_prompts.dart';

/// Result of "Explain to parents" feature split into 2 messages:
/// 1) kid-facing support
/// 2) parent-facing letter
class ExplainParentsParts {
  final String kidMessage;
  final String parentsLetter;

  /// Full raw AI output (optional but useful for debugging / fallback)
  final String raw;

  ExplainParentsParts({
    required this.kidMessage,
    required this.parentsLetter,
    required this.raw,
  });
}

class KidAiService {
  KidAiService._();
  static final KidAiService instance = KidAiService._();

  static const String _apiKey = String.fromEnvironment('OPENAI_API_KEY');
  static const String _endpoint = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-4o-mini';

  Future<String> supportKidChat(
    String userText, {
    required String systemPrompt,
    required String promptVersion,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY is empty');
    }

    debugPrint('[KidAI] $promptVersion');

    final body = {
      'model': _model,
      'temperature': 0.6,
      'max_tokens': 800,
      'messages': [
        {
          'role': 'system',
          'content': '$systemPrompt\n\n[INTERNAL] prompt_version=$promptVersion',
        },
        {'role': 'user', 'content': userText},
      ],
    };

    final res = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(res.body);
    return decoded['choices'][0]['message']['content'].toString().trim();
  }

  // =================================================
  // TEMP STUBS — required by existing UI
  // =================================================

  /// Used by voice input screens (temporary stub)
  Future<String> transcribeAudio(String filePath) async {
    throw UnimplementedError('transcribeAudio temporarily disabled');
  }

  // =================================================
  // "Explain to parents" — NEW: single AI call, split into 2 parts
  // =================================================

  /// Call AI ONCE and split response:
  /// - kid-facing support (Part 1)
  /// - parent-facing letter (Part 2)
  Future<ExplainParentsParts> makeExplainParentsParts({
    required String childText,
  }) async {
    final full = await supportKidChat(
      childText,
      systemPrompt: KidPrompts.currentKidExplainParentsPrompt,
      promptVersion: KidPrompts.currentKidExplainParentsKey,
    );

    final parts = _splitKidAndParents(full);

    return ExplainParentsParts(
      kidMessage: parts.$1,
      parentsLetter: parts.$2,
      raw: full,
    );
  }

  // =================================================
  // "Explain to parents" — SPLIT & ASYNC
  // =================================================

  /// FAST: kid-facing support only (used to respond immediately)
  Future<String> makeExplainParentsKidMessageQuick({
    required String childText,
  }) async {
    return supportKidChat(
      childText,
      systemPrompt: KidPrompts.currentKidExplainParentsKidPrompt,
      promptVersion: KidPrompts.currentKidExplainParentsKidKey,
    );
  }

  /// SLOW: parent-facing letter only (can be generated in background)
  Future<String> makeExplainParentsParentLetterSlow({
    required String childText,
  }) async {
    return supportKidChat(
      childText,
      systemPrompt: KidPrompts.currentKidExplainParentsParentPrompt,
      promptVersion: KidPrompts.currentKidExplainParentsParentKey,
    );
  }

  /// Backward-compatible method used by preview widgets:
  /// If you already have full AI output (from chat), pass it here
  /// so we DO NOT call AI again.
  Future<String> makeParentMessage({
    required String childText,
    String? cachedFullAiResponse,
  }) async {
    final full = (cachedFullAiResponse != null && cachedFullAiResponse.trim().isNotEmpty)
        ? cachedFullAiResponse.trim()
        : await supportKidChat(
            childText,
            systemPrompt: KidPrompts.currentKidExplainParentsPrompt,
            promptVersion: KidPrompts.currentKidExplainParentsKey,
          );

    return _extractParentsLetter(full) ?? full;
  }

  /// Try to split into (kidMessage, parentsLetter).
  /// Works even if model output is slightly different.
  (String, String) _splitKidAndParents(String full) {
    final t = full.trim();
    if (t.isEmpty) return ('', '');

    // 1) Try strict markers (best)
    // We accept multiple common Ukrainian variants.
    final part2Start = _findEarliestIndex(t, <String>[
      'Частина 2:',
      'Частина 2',
      'Лист для батьків:',
      'Лист для батьків',
      'Для батьків:',
      'Для батьків',
      'Шановні батьки',
      'Тема:',
    ]);

    // If we found where parent letter starts, kid part is before it.
    if (part2Start != null && part2Start > 0) {
      final kidRaw = t.substring(0, part2Start).trim();
      final parentsRaw = t.substring(part2Start).trim();

      final kid = _cleanKidPart(kidRaw);
      final parents = _cleanParentsPart(parentsRaw);

      // If kid part accidentally empty, still provide a soft fallback.
      if (kid.isEmpty) {
        return ('Я тебе почув(ла). Дякую, що поділився(лася).', parents);
      }
      return (kid, parents);
    }

    // 2) Fallback: if we can at least extract parents letter, use it.
    final parents = _extractParentsLetter(t);
    if (parents != null && parents.isNotEmpty) {
      // kid = everything before parents marker
      final idx = t.indexOf(parents);
      if (idx > 0) {
        final kid = _cleanKidPart(t.substring(0, idx).trim());
        return (kid.isEmpty ? 'Я тебе почув(ла). Дякую, що поділився(лася).' : kid, _cleanParentsPart(parents));
      }
      // If we found parents but not position, still return something
      return ('Я тебе почув(ла). Дякую, що поділився(лася).', _cleanParentsPart(parents));
    }

    // 3) Last resort: we cannot split reliably. Treat all as kid message.
    // Parents letter becomes empty (UI can hide the button or show “не знайдено”).
    return (_cleanKidPart(t), '');
  }

  String _cleanKidPart(String s) {
    var out = s.trim();

    // Remove common headings if present
    out = _removeLeadingAny(out, <String>[
      'Частина 1:',
      'Частина 1',
      'Відповідь дитині:',
      'Відповідь для дитини:',
      'Для дитини:',
      'Для дитини',
    ]);

    return out.trim();
  }

  String _cleanParentsPart(String s) {
    var out = s.trim();

    // Keep the parent letter nice: allow starting from "Лист..." or "Шановні батьки"
    // but remove duplicate label lines if needed.
    out = _removeLeadingAny(out, <String>[
      'Частина 2:',
      'Частина 2',
    ]);

    return out.trim();
  }

  String? _extractParentsLetter(String full) {
    final t = full.trim();
    if (t.isEmpty) return null;

    final markers = <String>[
      'Лист для батьків:',
      'Лист для батьків',
      'Частина 2:',
      'Частина 2',
      'Для батьків:',
      'Для батьків',
      'Шановні батьки',
      'Тема:',
    ];

    int? bestIdx;
    for (final m in markers) {
      final idx = t.indexOf(m);
      if (idx >= 0 && (bestIdx == null || idx < bestIdx)) {
        bestIdx = idx;
      }
    }

    if (bestIdx == null) return null;
    return t.substring(bestIdx).trim();
  }

  int? _findEarliestIndex(String text, List<String> markers) {
    int? best;
    for (final m in markers) {
      final idx = text.indexOf(m);
      if (idx >= 0 && (best == null || idx < best)) best = idx;
    }
    return best;
  }

  String _removeLeadingAny(String text, List<String> prefixes) {
    var out = text.trimLeft();
    for (final p in prefixes) {
      if (out.startsWith(p)) {
        out = out.substring(p.length).trimLeft();
      }
    }
    return out;
  }

  /// Used by curiosity / ask-AI screen
  Future<String> answerCuriosity(String question) async {
    return supportKidChat(
      question,
      systemPrompt: 'Ти добрий і простий помічник для дитини. Відповідай коротко.',
      promptVersion: 'kid_curiosity_v1',
    );
  }
}