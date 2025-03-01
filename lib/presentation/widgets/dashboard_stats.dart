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
import 'package:flutter/material.dart';
import '../../core/utils/size_config.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard(
          context,
          title: 'Calories',
          value: '450',
          unit: 'kcal',
          icon: Icons.local_fire_department,
          iconColor: Colors.orange,
          progressValue: 0.45,
        ),
        _buildStatCard(
          context,
          title: 'Workouts',
          value: '2',
          unit: '/4',
          icon: Icons.fitness_center,
          iconColor: Colors.blue,
          progressValue: 0.5,
        ),
        _buildStatCard(
          context,
          title: 'Water',
          value: '1.5',
          unit: 'L',
          icon: Icons.water_drop,
          iconColor: Colors.lightBlue,
          progressValue: 0.6,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required double progressValue,
  }) {
    return Container(
      width: SizeConfig.screenWidth! * 0.28,
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          RichText(
            text: TextSpan(
              text: value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: unit,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            borderRadius: BorderRadius.circular(10),
            minHeight: 5,
          ),
        ],
      ),
    );
  }
}
