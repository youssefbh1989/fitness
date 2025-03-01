
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final IconData icon;
  
  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.icon = Icons.sentiment_dissatisfied,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onButtonPressed,
              child: Text(buttonText!),
            ),
          ],
        ],
      ),
    );
  }
}
