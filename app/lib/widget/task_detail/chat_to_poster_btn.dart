import 'package:app/widget/screen/chat_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ChatToPosterBtn extends StatelessWidget {
  final String receiverId;
  final String currentUserId;
  const ChatToPosterBtn({
    super.key,
    required this.receiverId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      ChatScreen(userId: currentUserId, receiverId: receiverId),
            ),
          );
        },
        icon: Icon(FluentIcons.chat_20_filled),
        label: Text('chatToPoster'.tr()),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
