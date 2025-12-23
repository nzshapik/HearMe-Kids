import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'kid_prompts.dart';

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

  /// Used by "Explain to parents" preview widgets
  /// Returns ONLY the parent-facing letter (Part 2), extracted from the full AI response.
  Future<String> makeParentMessage({required String childText}) async {
    final full = await supportKidChat(
      childText,
      systemPrompt: KidPrompts.currentKidExplainParentsPrompt,
      promptVersion: KidPrompts.currentKidExplainParentsKey,
    );
    return _extractParentsLetter(full) ?? full;
  }

  String? _extractParentsLetter(String full) {
    final t = full.trim();
    if (t.isEmpty) return null;

    // Common markers we expect from the prompt / model outputs
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

  /// Used by curiosity / ask-AI screen
  Future<String> answerCuriosity(String question) async {
    return supportKidChat(
      question,
      systemPrompt: 'Ти добрий і простий помічник для дитини. Відповідай коротко.',
      promptVersion: 'kid_curiosity_v1',
    );
  }
}