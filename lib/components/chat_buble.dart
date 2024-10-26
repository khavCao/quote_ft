import 'package:flutter/material.dart';

class ChatBuble extends StatelessWidget {
  final String message;
  const ChatBuble({super.key,
    required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(message, style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}