
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    Key? key,
    required this.title,
    this.actionText = 'See All',
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (onActionPressed != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(
              actionText,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
      ],
    );
  }
}
