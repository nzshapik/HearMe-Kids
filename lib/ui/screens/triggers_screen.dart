import 'package:flutter/material.dart';

class TriggersScreen extends StatefulWidget {
  const TriggersScreen({super.key});

  @override
  State<TriggersScreen> createState() => _TriggersScreenState();
}

class _TriggersScreenState extends State<TriggersScreen> {
  final Set<String> _selected = {};

  final List<String> _presets = const [
    'Time together',
    'Household tasks',
    'Money & spending',
    'Parenting styles',
    'Jealousy & trust',
    'Phones & social media',
    'Sex & intimacy',
    'Work vs family',
    'In-laws / relatives',
  ];

  // Нові поля для кастомних тригерів
  final TextEditingController _customController = TextEditingController();
  final List<String> _customTriggers = [];

  // Нові поля для градації сили
  final List<String> _severityLevels = const [
    'It upsets me',
    'It irritates me',
    'It really hurts',
    'It feels unacceptable',
  ];

  String? _selectedSeverity;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _toggle(String label) {
    setState(() {
      if (_selected.contains(label)) {
        _selected.remove(label);
      } else {
        _selected.add(label);
      }
    });
  }

  void _addCustomTrigger() {
    final raw = _customController.text.trim();
    if (raw.isEmpty) return;

    // Уникаємо дублікатів
    if (_presets.contains(raw) || _customTriggers.contains(raw)) {
      _customController.clear();
      return;
    }

    setState(() {
      _customTriggers.add(raw);
      _selected.add(raw); // одразу вважаємо обраним
      _customController.clear();
    });
  }

  void _selectSeverity(String level) {
    setState(() {
      _selectedSeverity = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF4F7FF),
              Color(0xFFF9FAFB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),

                            // Header
                            Text(
                              'Soft triggers',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'What usually feels sensitive?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pick topics that often lead to tension between you. HearMe will treat these areas more carefully.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: colorScheme.onBackground.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Card with preset triggers
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFFE0E7FF),
                                              Color(0xFFD1FAE5),
                                            ],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.warning_amber_rounded,
                                            size: 18,
                                            color: Color(0xFF4B5563),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Text(
                                          'Common soft spots',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      ..._presets.map(
                                        (label) => _TriggerChip(
                                          label: label,
                                          selected: _selected.contains(label),
                                          onTap: () => _toggle(label),
                                        ),
                                      ),
                                      // Кастомні тригери в тому ж стилі
                                      ..._customTriggers.map(
                                        (label) => _TriggerChip(
                                          label: label,
                                          selected: _selected.contains(label),
                                          onTap: () => _toggle(label),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Severity card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFE0E7FF),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.thermostat_auto_rounded,
                                            size: 18,
                                            color: Color(0xFF4B5563),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'How strong does this usually feel?',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF111827),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Roughly, how intense do these topics feel for you right now?',
                                              style: TextStyle(
                                                fontSize: 12,
                                                height: 1.4,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _severityLevels
                                        .map(
                                          (level) => _SeverityChip(
                                            label: level,
                                            selected: _selectedSeverity == level,
                                            onTap: () => _selectSeverity(level),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // "Anything else?" card with input + Add button
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Anything else?',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9FAFB),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: TextField(
                                      controller: _customController,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: const InputDecoration(
                                        isCollapsed: true,
                                        border: InputBorder.none,
                                        hintText: 'For example: Being late to important events…',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: OutlinedButton.icon(
                                      onPressed: _addCustomTrigger,
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: const StadiumBorder(),
                                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                                      ),
                                      icon: const Icon(Icons.add_rounded, size: 18),
                                      label: const Text(
                                        'Add',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // How this helps card (як у Positive Anchors)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFEDE9FE),
                                    Color(0xFFE0F2FE),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.lightbulb_outline,
                                        size: 18,
                                        color: Color(0xFF7C3AED),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'How this helps',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'When HearMe knows your soft spots, it can be extra gentle around these topics — helping you slow down before things get too heated.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.4,
                                            color: Color(0xFF374151),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bottom buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () {
                          // TODO: зберегти тригери та градацію локально
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        },
                        style: FilledButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: const Color(0xFF4BC59E),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Save & Continue'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Skip for now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TriggerChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TriggerChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? const Color(0xFF7C3AED) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF7C3AED) : const Color(0xFFD1D5DB),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class _SeverityChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SeverityChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? const Color(0xFF4BC59E) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF4BC59E) : const Color(0xFFD1D5DB),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4BC59E).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}