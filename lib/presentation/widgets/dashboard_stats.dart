import 'package:flutter/material.dart';
import '../../core/utils/size_config.dart';

class DashboardStats extends StatelessWidget {
  final int completedWorkouts;
  final int burnedCalories;
  final int activeMinutes;

  const DashboardStats({
    Key? key,
    required this.completedWorkouts,
    required this.burnedCalories,
    required this.activeMinutes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            Icons.fitness_center_outlined,
            completedWorkouts.toString(),
            'Workouts',
          ),
          _buildDivider(),
          _buildStatItem(
            context,
            Icons.local_fire_department_outlined,
            burnedCalories.toString(),
            'Calories',
          ),
          _buildDivider(),
          _buildStatItem(
            context,
            Icons.timer_outlined,
            activeMinutes.toString(),
            'Minutes',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        SizedBox(height: SizeConfig.smallPadding),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }
}