import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(BuildContext context, String? message) {
    if (message == null || message.isEmpty) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
