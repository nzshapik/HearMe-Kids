// 🟩 CalmMessageAiService
// Викликає OpenAI, щоб переписати емоційне повідомлення у спокійні варіанти в різних стилях.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Ключі стилів, внутрішні технічні назви.
enum CalmStyleKey {
  main, // збалансований: чесно + тепло + структурно
  nvc,  // Nonviolent Communication (спостереження / почуття / потреба / прохання)
  warm, // максимально емпатичний, «обіймаючий»
}

extension CalmStyleKeyX on CalmStyleKey {
  /// Технічне імʼя для збереження в SharedPreferences.
  String get storageKey {
    switch (this) {
      case CalmStyleKey.main:
        return 'main';
      case CalmStyleKey.nvc:
        return 'nvc';
      case CalmStyleKey.warm:
        return 'warm';
    }
  }

  /// Дефолтна назва стилю, яку бачить користувач, якщо він не перейменував.
  String get defaultLabel {
    switch (this) {
      case CalmStyleKey.main:
        return 'Balanced';
      case CalmStyleKey.nvc:
        return 'NVC / Я-повідомлення';
      case CalmStyleKey.warm:
        return 'Теплий / емпатичний';
    }
  }

  static CalmStyleKey? fromStorage(String? value) {
    switch (value) {
      case 'main':
        return CalmStyleKey.main;
      case 'nvc':
        return CalmStyleKey.nvc;
      case 'warm':
        return CalmStyleKey.warm;
      default:
        return null;
    }
  }
}

/// Один варіант переписаного повідомлення в певному стилі.
class CalmStyleVariant {
  final CalmStyleKey key;
  final String label; // назва стилю, яку бачить користувач
  final String text; // сам переписаний текст

  CalmStyleVariant({
    required this.key,
    required this.label,
    required this.text,
  });
}

/// Результат генерації: список варіантів у різних стилях.
class CalmMessageResult {
  final List<CalmStyleVariant> variants;

  CalmMessageResult({required this.variants});
}

// 🧠 Збереження налаштувань стилю
class CalmStylePreferences {
  CalmStylePreferences._();

  static final instance = CalmStylePreferences._();

  static const _preferredStyleKey = 'calm_preferred_style_key';
  static const _styleLabelPrefix = 'calm_style_label_';

  Future<CalmStyleKey?> getPreferredStyle() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_preferredStyleKey);
    return CalmStyleKeyX.fromStorage(stored);
  }

  Future<void> setPreferredStyle(CalmStyleKey key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferredStyleKey, key.storageKey);
  }

  /// Повертає кастомну назву стилю, якщо є, або дефолтну.
  Future<String> getStyleLabel(CalmStyleKey key) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('$_styleLabelPrefix${key.storageKey}');
    return stored?.trim().isNotEmpty == true ? stored! : key.defaultLabel;
  }

  /// Зберігає користувацьку назву стилю.
  Future<void> setStyleLabel(CalmStyleKey key, String label) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_styleLabelPrefix${key.storageKey}', label.trim());
  }
}

// 🧩 Сервіс виклику OpenAI
class CalmMessageAiService {
  CalmMessageAiService._();

  static final instance = CalmMessageAiService._();

  // ⚠️ ТІЛЬКИ ДЛЯ ЛОКАЛЬНОГО ТЕСТУ!
  // В проді ключ треба зберігати на бекенді.
  // 🔑 СЮДИ ВСТАВ СВІЙ OPENAI API KEY (локально):
  static const String _apiKey = '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';

  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// Старий метод, щоб нічого не зламати.
  /// Тепер це просто balanced (main) стиль.
  Future<String> transformToCalmMessage(String rawText) {
    return transformSingleStyle(rawText, CalmStyleKey.main);
  }

  /// Повертає одне переписане повідомлення в одному стилі.
  /// Використовуємо, коли вже є улюблений стиль.
  Future<String> transformSingleStyle(
    String rawText,
    CalmStyleKey styleKey,
  ) async {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Text is empty');
    }

    final systemPrompt = _buildSystemPrompt(styleKey);
    final content = await _callOpenAi(systemPrompt: systemPrompt, userText: trimmed);
    return content;
  }

  /// Повертає всі три стилі за один прохід (3 паралельні запити).
  /// Використовуємо на першому запуску або коли юзер тисне "Показати інші стилі".
  Future<CalmMessageResult> transformAllStyles(String rawText) async {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Text is empty');
    }

    final styles = CalmStyleKey.values;

    final futures = styles.map((styleKey) async {
      final systemPrompt = _buildSystemPrompt(styleKey);
      final text = await _callOpenAi(systemPrompt: systemPrompt, userText: trimmed);

      // Поки що беремо дефолтні назви. На UI ти зможеш витягнути
      // кастомні через CalmStylePreferences.instance.getStyleLabel(...)
      final label = styleKey.defaultLabel;

      return CalmStyleVariant(
        key: styleKey,
        label: label,
        text: text,
      );
    }).toList();

    final variants = await Future.wait(futures);
    return CalmMessageResult(variants: variants);
  }

  /// Базовий виклик OpenAI, спільний для всіх стилів.
  Future<String> _callOpenAi({
    required String systemPrompt,
    required String userText,
  }) async {
    final apiKey = _apiKey.trim();
    if (apiKey.isEmpty || apiKey == 'PASTE_YOUR_OPENAI_API_KEY_HERE') {
      throw Exception('OpenAI API key is missing. Paste a valid key into CalmMessageAiService._apiKey');
    }

    final uri = Uri.parse(_apiUrl);

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': [
        {
          'role': 'system',
          'content': systemPrompt,
        },
        {
          'role': 'user',
          'content': userText,
        },
      ],
      'temperature': 0.7,
      'max_tokens': 300,
    });

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception(
          'OpenAI error 401 (Unauthorized). The API key was rejected. This usually means the key is invalid, revoked, or belongs to a different account/project. Response: ${response.body}',
        );
      }
      if (response.statusCode == 429) {
        throw Exception(
          'OpenAI error 429 (Rate limit / quota). You may have no quota or you hit a rate limit. Response: ${response.body}',
        );
      }
      throw Exception(
        'OpenAI error: ${response.statusCode} – ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('No choices returned from OpenAI');
    }

    final message = choices.first['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw Exception('Empty content from OpenAI');
    }

    return content.trim();
  }

  /// Будуємо system prompt під конкретний стиль.
  String _buildSystemPrompt(CalmStyleKey styleKey) {
    const base = '''
You are an AI assistant that rewrites emotionally charged relationship messages into calm, clear, respectful versions.

General rules:
- Keep the original meaning and intention.
- Remove accusations, labels and "you always / you never".
- Use "I feel" / "I need" instead of blame.
- Be kind, honest and direct.
- Keep it short, conversational and natural.
- Do NOT add explanations, comments or bullet points — only send the rewritten message as if the user will paste it into a chat.
''';

    const mainStyle = '''
Style: BALANCED
- Blend honesty, warmth and structure.
- Keep it real and grounded, not sugar-coated.
- Show that the situation matters to the speaker, but without attacking the other person.
- Make it feel like a mature adult, who бере відповідальність за свої почуття.
''';

    const nvcStyle = '''
Style: NVC / I-message
- Use Nonviolent Communication structure:
  1) Observation (без оцінок)
  2) Feeling ("I feel...")
  3) Need ("I need / It is important for me that...")
  4) Request (конкретне, реалістичне прохання)
- Avoid any blaming or diagnosing the other person.
''';

    const warmStyle = '''
Style: WARM / EMPATHETIC
- Sound very gentle, supportive and caring.
- Start from empathy: recognize the difficulty and emotions of both sides.
- Focus on connection and "we are a team".
- Still be honest about what hurts and what is needed, але максимально мʼяко.
''';

    switch (styleKey) {
      case CalmStyleKey.main:
        return '$base\n$mainStyle';
      case CalmStyleKey.nvc:
        return '$base\n$nvcStyle';
      case CalmStyleKey.warm:
        return '$base\n$warmStyle';
    }
  }
}