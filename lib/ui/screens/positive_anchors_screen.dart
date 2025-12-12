import 'package:flutter/material.dart';

class PositiveAnchorsScreen extends StatelessWidget {
  const PositiveAnchorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFF6FF),
              Color(0xFFF9FAFB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Positive Anchors',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Reminders of why you chose each other',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Why I Appreciate You
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFD1FAE5),
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 20,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Why I Appreciate You',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 26,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Write 3 things you love or deeply value about your partner',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const _AnchorLineInput(
                            hint: 'Tap to add what you value…',
                          ),
                          const SizedBox(height: 8),
                          const _AnchorLineInput(
                            hint: 'Tap to add what you value…',
                          ),
                          const SizedBox(height: 8),
                          const _AnchorLineInput(
                            hint: 'Tap to add what you value…',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Our Best Moments Together
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF5F3FF),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            size: 20,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Our Best Moments Together',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 26,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              _MemoryChip(label: '✨ Weekend in the mountains'),
                              _MemoryChip(label: '✨ First concert together'),
                              _MemoryChip(label: '✨ The day we adopted Luna'),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: const [
                              Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: Color(0xFF4B5563),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Add Memory',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Photos That Bring Us Back to Love
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE0F2FE),
                          ),
                          child: const Icon(
                            Icons.photo_camera_back_rounded,
                            size: 20,
                            color: Color(0xFF0EA5E9),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Photos That Bring Us Back to Love',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 26,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _MainPhotoCard(),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              _PhotoThumbnailPlaceholder(),
                              _PhotoThumbnailPlaceholder(),
                              _PhotoThumbnailPlaceholder(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'These photos stay on your device. During tense moments, HearMe can gently show one as a reminder.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const _HowThisHelpsCard(),

                    const SizedBox(height: 28),

                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/triggers');
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
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/triggers');
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
                    ),
                    const SizedBox(height: 16),
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

class _AnchorLineInput extends StatelessWidget {
  final String hint;

  const _AnchorLineInput({required this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.favorite_rounded,
          size: 18,
          color: Color(0xFF10B981),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MemoryChip extends StatelessWidget {
  final String label;

  const _MemoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFF3E8FF),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF7C3AED),
        ),
      ),
    );
  }
}

class _MainPhotoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE5F3FF),
            Color(0xFFF4E9FF),
          ],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.35),
              ),
              child: const Center(
                child: Icon(
                  Icons.favorite_border_rounded,
                  size: 36,
                  color: Color(0xFF22C55E),
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment(0, 0.45),
            child: Text(
              'Your romantic photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF34D399),
                      Color(0xFF4ADE80),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Main anchor photo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoThumbnailPlaceholder extends StatelessWidget {
  const _PhotoThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFFF3F4F6),
      ),
      child: const Center(
        child: Icon(
          Icons.photo_rounded,
          size: 26,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}

class _HowThisHelpsCard extends StatelessWidget {
  const _HowThisHelpsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF3E8FF),
            Color(0xFFE0F2FE),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFDE68A),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              size: 22,
              color: Color(0xFF92400E),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How This Helps',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'When HearMe detects rising tension, it can gently suggest looking at these anchors together — shifting focus from conflict to connection.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}