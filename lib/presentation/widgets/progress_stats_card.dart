
import 'package:flutter/material.dart';
import '../../core/utils/size_config.dart';

class ProgressStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const ProgressStatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.iconColor = const Color(0xFF4CAF50),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.defaultPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                ),
                SizedBox(width: SizeConfig.smallPadding),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.smallPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(width: SizeConfig.smallPadding / 2),
                Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.smallPadding / 2),
                  child: Text(
                    unit,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
