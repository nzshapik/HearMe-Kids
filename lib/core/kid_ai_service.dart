import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/kid_ai_service.dart' as core_ai;
import '../../core/kid_prompts.dart';

class _KidTalkChatScreenState extends State<KidTalkChatScreen> {
  Future<void> _askAi(String userText) async {
    final reply = await core_ai.KidAiService.instance.supportKidChat(
      userText,
      systemPrompt: KidPrompts.currentKidTalkPrompt,
      promptVersion: KidPrompts.currentKidTalkKey,
    );
    // решта коду...
  }
  
  // інший код класу...
}