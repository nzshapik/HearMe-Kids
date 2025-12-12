import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewConflictScreen extends ConsumerWidget {
  const NewConflictScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новий запис'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            'Опишіть своїми словами останній конфлікт.\n\n'
            '• Що сталося? \n'
            '• Які фрази або дії поранили вас найбільше?\n'
            '• Що ви відчували в той момент?\n\n'
            'Цей опис допоможе HearMe виявити тригери, непорозуміння та підготувати мʼякий аналіз для вас обох.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}