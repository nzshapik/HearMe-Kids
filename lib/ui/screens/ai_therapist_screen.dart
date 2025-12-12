import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Сервіс для AI Therapist
class AiTherapistAiService {
  AiTherapistAiService._();

  static final instance = AiTherapistAiService._();

  // ⚠️ ТІЛЬКИ ДЛЯ ЛОКАЛЬНОГО ТЕСТУ!
  // В продакшені ключ потрібно зберігати на бекенді.
  static const String _apiKey = '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';

  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// Основний метод:
  /// - [rawText] — ситуація / повідомлення, яке описує користувач
  /// - [role] — хто пише: 'parent' або 'child' (на майбутнє)
  Future<String> getTherapistReply({
    required String rawText,
    String role = 'parent',
  }) async {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Text is empty');
    }

    final systemPrompt = _buildSystemPrompt(role: role);

    final content = await _callOpenAi(
      systemPrompt: systemPrompt,
      userText: trimmed,
    );

    return content;
  }

  /// Базовий виклик OpenAI (майже як у CalmMessageAiService)
  Future<String> _callOpenAi({
    required String systemPrompt,
    required String userText,
  }) async {
    final uri = Uri.parse(_apiUrl);

    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': [
        {
          'role': 'system',
          'content':
              'Ти — емпатичний, досвідчений дитячий психолог. Завжди відповідай українською мовою, у теплій і підтримуючій манері. Дотримуйся інструкцій від розробника як головних правил роботи.'
        },
        {
          'role': 'developer',
          'content': systemPrompt,
        },
        {
          'role': 'user',
          'content': userText,
        },
      ],
      'temperature': 0.6,
      'max_tokens': 1200,
    });

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception(
        'OpenAI error (AI Therapist): ${response.statusCode} – ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('No choices returned from OpenAI (AI Therapist)');
    }

    final message = choices.first['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw Exception('Empty content from OpenAI (AI Therapist)');
    }

    return content.trim();
  }

  /// Будуємо system prompt під роль (батько / дитина) — ТВОЙ НОВИЙ ПРОМПТ
  String _buildSystemPrompt({required String role}) {
    final roleContext = role == 'child'
        ? 'Користувач описує ситуацію частіше з перспективи дитини або хоче краще зрозуміти внутрішній світ дитини.'
        : 'Користувач — батько / мама, який описує поведінку своєї дитини і хоче зрозуміти, що за цим стоїть.';

    return """
$roleContext

Ти — досвідчений, емпатичний дитячий психолог із глибоким знанням вікової психології, теорії прихильності та нейробіології розвитку дитини. Твоя мета — допомогти батькам зрозуміти справжні причини поведінки їхньої дитини, знизити тривожність батьків та надати конструктивні інструменти для взаємодії.

КОНТЕКСТ:
Батьки часто бачать лише зовнішній прояв поведінки (істерика, агресія, мовчання), але не розуміють глибинних потреб дитини. Твоє завдання — проаналізувати ситуацію та "перекласти" поведінку дитини на мову потреб.

ЗАВЖДИ ВІДПОВІДАЙ УКРАЇНСЬКОЮ МОВОЮ.

ІНСТРУКЦІЇ ДЛЯ АНАЛІЗУ:
Коли користувач описує ситуацію, дій за таким алгоритмом:

1. ЕМПАТІЯ ТА ВАЛІДАЦІЯ (1–2 речення)
- Почни з підтримки батьків.
- Визнай, що їхні почуття нормальні, а ситуація справді може бути складною.
- М’яко зніми почуття провини.

2. ВІКОВИЙ КОНТЕКСТ
- Коротко поясни, чи є така поведінка типовою для певного віку (наприклад, криза 3 років, молодший шкільний вік, підлітковий бунт тощо).
- Зв’яжи це з особливостями розвитку мозку та нервової системи дитини.

3. ЩО ЦЕ ОЗНАЧАЄ (ПЕРЕКЛАД ПОВЕДІНКИ)
- Поясни, що насправді може "говорити" поведінка дитини.
- Наприклад: «Коли дитина кричить "Я тебе ненавиджу", насправді вона може повідомляти: "Я не справляюся з цими емоціями, мені страшно і боляче"».

4. ЩО ПРИХОВУЄ ПОВЕДІНКА (ГЛИБИННИЙ АНАЛІЗ)
- Використовуй підхід HALT (Hungry, Angry, Lonely, Tired) та базові потреби:
  - безпека;
  - контроль / передбачуваність;
  - увага та емоційний контакт;
  - прийняття та безумовна любов.
- Визнач, чого дитині може бракувати саме зараз і які тригери могли спрацювати.

5. РЕКОМЕНДАЦІЇ (КОНКРЕТНІ КРОКИ)
- Дай 3 практичні поради:
  - що можна зробити «тут і зараз», у конкретній ситуації;
  - що робити «на перспективу» для профілактики подібних епізодів.
- Обов’язково додай приклади конкретних фраз (скриптів), які батьки можуть сказати дитині. Наприклад:
  - «Я бачу, що тобі дуже складно зараз зупинитися, і це нормально злитися. Я поруч».
  - «Твої почуття важливі для мене, давай разом подумаємо, як зробити цю ситуацію трішки легшою для тебе».

ОБМЕЖЕННЯ:
- Не став медичних діагнозів (РДУГ, аутизм тощо).
- Якщо ти помічаєш можливі «червоні прапорці» (дуже інтенсивна, небезпечна для життя поведінка, самопошкодження, повна відсутність контакту), м’яко порадь звернутися до очного спеціаліста (дитячий психолог / психіатр).
- Не використовуй складну професійну термінологію без пояснення простими словами.
- Тон спілкування: теплий, підтримуючий, без осуду, без звинувачення батьків.

ФОРМАТ ВІДПОВІДІ:
- Використовуй чітку структуру з підзаголовками:
  1) «Емпатія та підтримка»
  2) «Що відбувається з дитиною»
  3) «Що може стояти за цією поведінкою»
  4) «Що ви можете зробити зараз»
  5) «Що робити в довгостроковій перспективі»
- Для рекомендацій використовуй марковані списки.

ПАМ’ЯТАЙ:
Твоє головне завдання — знизити тривожність батьків, допомогти їм побачити за поведінкою дитини її потреби та дати їм відчуття: «Я не поганий батько/мати, я можу навчитися інакше реагувати».

""";
  }
}

class AiTherapistSessionEntry {
  final String question;
  final String answer;
  final DateTime createdAt;

  AiTherapistSessionEntry({
    required this.question,
    required this.answer,
    required this.createdAt,
  });
}

class AiTherapistSessionStore {
  AiTherapistSessionStore._();

  static final instance = AiTherapistSessionStore._();

  final List<AiTherapistSessionEntry> sessions = [];
}

class AiTherapistScreen extends StatefulWidget {
  const AiTherapistScreen({super.key});

  @override
  State<AiTherapistScreen> createState() => _AiTherapistScreenState();
}

class _AiTherapistScreenState extends State<AiTherapistScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _reply;

  Future<void> _sendToAi() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _reply = null;
    });

    try {
      final answer = await AiTherapistAiService.instance.getTherapistReply(
        rawText: text,
        role: 'parent', // поки що фіксовано як батько
      );

      setState(() {
        _reply = answer;
        AiTherapistSessionStore.instance.sessions.insert(
          0,
          AiTherapistSessionEntry(
            question: text,
            answer: answer,
            createdAt: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _reply =
            'Сталася помилка при зверненні до AI Therapist. Спробуй ще раз.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Therapist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Опиши ситуацію, вік дитини і що саме тебе турбує...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendToAi,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Запитати AI'),
              ),
              const SizedBox(height: 20),
              if (_reply != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    _reply!,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}