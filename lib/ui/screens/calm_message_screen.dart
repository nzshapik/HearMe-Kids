import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calm_message_ai_service.dart';


class CalmMessageScreen extends StatefulWidget {
  const CalmMessageScreen({super.key});

  @override
  State<CalmMessageScreen> createState() => _CalmMessageScreenState();
}

class _CalmMessageScreenState extends State<CalmMessageScreen> {
  final TextEditingController emotionalCtrl = TextEditingController();

  bool _isLoading = false;
  String? _errorText;
  List<CalmStyleVariant> _variants = [];
  CalmStyleKey? _preferredStyleKey;

  @override
  void initState() {
    super.initState();
    _loadPreferredStyle();
  }

  @override
  void dispose() {
    emotionalCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadPreferredStyle() async {
    final prefs = CalmStylePreferences.instance;
    final key = await prefs.getPreferredStyle();
    if (!mounted) return;
    setState(() {
      _preferredStyleKey = key;
    });
  }

  Future<void> _onTransformPressed() async {
    final rawText = emotionalCtrl.text.trim();
    if (rawText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Напиши спочатку емоційне повідомлення 🙂')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
      _variants = [];
    });

    try {
      if (_preferredStyleKey == null) {
        // Перший запуск або ще немає стилю за замовчуванням → усі 3 варіанти.
        await _generateAllStyles(rawText);
      } else {
        // Є улюблений стиль → генеруємо тільки його.
        await _generateSingleStyle(rawText, _preferredStyleKey!);
      }
    } catch (e) {
      setState(() {
        _errorText = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _generateAllStyles(String rawText) async {
    final service = CalmMessageAiService.instance;
    final prefs = CalmStylePreferences.instance;

    final result = await service.transformAllStyles(rawText);

    final updated = <CalmStyleVariant>[];
    for (final v in result.variants) {
      final label = await prefs.getStyleLabel(v.key);
      updated.add(
        CalmStyleVariant(
          key: v.key,
          label: label,
          text: v.text,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _variants = updated;
    });
  }

  Future<void> _generateSingleStyle(String rawText, CalmStyleKey key) async {
    final service = CalmMessageAiService.instance;
    final prefs = CalmStylePreferences.instance;

    final text = await service.transformSingleStyle(rawText, key);
    final label = await prefs.getStyleLabel(key);

    if (!mounted) return;
    setState(() {
      _variants = [
        CalmStyleVariant(
          key: key,
          label: label,
          text: text,
        )
      ];
    });
  }

  Future<void> _onShowOtherStyles() async {
    final rawText = emotionalCtrl.text.trim();
    if (rawText.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
      _variants = [];
    });

    try {
      await _generateAllStyles(rawText);
    } catch (e) {
      setState(() {
        _errorText = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _setDefaultStyle(CalmStyleKey key) async {
    final prefs = CalmStylePreferences.instance;
    await prefs.setPreferredStyle(key);

    if (!mounted) return;
    setState(() {
      _preferredStyleKey = key;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Стиль збережено як стиль за замовчуванням ✅')),
    );
  }

  Future<void> _renameStyle(CalmStyleVariant variant) async {
    final controller = TextEditingController(text: variant.label);
    final prefs = CalmStylePreferences.instance;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Перейменувати стиль'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Нова назва стилю',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) return;

    await prefs.setStyleLabel(variant.key, result);

    if (!mounted) return;
    setState(() {
      _variants = _variants
          .map(
            (v) => v.key == variant.key
                ? CalmStyleVariant(
                    key: v.key,
                    label: result,
                    text: v.text,
                  )
                : v,
          )
          .toList();
    });
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Текст скопійовано 📋')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPreferred = _preferredStyleKey != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  centerTitle: true,
  title: const Text(
    'Calm Message • STYLES',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  ),
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Your Emotional Draft',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Text(
              'Type honestly how you feel',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Поле емоційного тексту
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: emotionalCtrl,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your emotional message…',
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Кнопка Transform
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onTransformPressed,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  backgroundColor: const Color(0xFF7A3EFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Transform ↓',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 25),

            if (_variants.isNotEmpty || _errorText != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Calm Version',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    hasPreferred
                        ? 'Стиль, який ми використовуємо зараз'
                        : 'Оберіть стиль, який вам підходить',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            if (_errorText != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _errorText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade700,
                  ),
                ),
              ),

            // Картки стилів
            if (_variants.isNotEmpty)
              Column(
                children: _variants
                    .map(
                      (v) => _StyleCard(
                        variant: v,
                        isDefault: _preferredStyleKey == v.key,
                        onCopy: () => _copyToClipboard(v.text),
                        onSetDefault: () => _setDefaultStyle(v.key),
                        onRename: () => _renameStyle(v),
                      ),
                    )
                    .toList(),
              ),

            // Кнопка "Показати інші стилі" якщо вже є дефолт і показана 1 картка
            if (_variants.length == 1 && hasPreferred && !_isLoading)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _onShowOtherStyles,
                  child: const Text('Показати інші стилі'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final CalmStyleVariant variant;
  final bool isDefault;
  final VoidCallback onCopy;
  final VoidCallback onSetDefault;
  final VoidCallback onRename;

  const _StyleCard({
    required this.variant,
    required this.isDefault,
    required this.onCopy,
    required this.onSetDefault,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? const Color(0xFF7A3EFE) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок картки
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  variant.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isDefault)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A3EFE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7A3EFE),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              IconButton(
                onPressed: onRename,
                icon: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey,
                ),
                tooltip: 'Перейменувати стиль',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            variant.text,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCopy,
                  child: const Text('Use now'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSetDefault,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A3EFE),
                  ),
                  child: Text(isDefault ? 'Default' : 'Set as default'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}