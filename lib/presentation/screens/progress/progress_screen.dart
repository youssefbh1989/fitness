import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/size_config.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/progress_stats_card.dart';
import '../../widgets/dashboard_stats.dart';
import 'progress_chart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _lastSevenDays = List.generate(7, (index) {
    final date = DateTime.now().subtract(Duration(days: 6 - index));
    return DateFormat('E').format(date);
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Your Progress',
              showBackButton: false,
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Weekly'),
                Tab(text: 'Monthly'),
                Tab(text: 'Yearly'),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWeeklyTab(),
                  _buildMonthlyTab(),
                  _buildYearlyTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week\'s Stats',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: SizeConfig.defaultPadding),

          // Dashboard stats summary
          DashboardStats(
            completedWorkouts: 5,
            burnedCalories: 1250,
            activeMinutes: 320,
          ),

          SizedBox(height: SizeConfig.mediumPadding),

          Text(
            'Body Metrics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: SizeConfig.defaultPadding),

          // Body metrics grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: SizeConfig.defaultPadding,
            crossAxisSpacing: SizeConfig.defaultPadding,
            childAspectRatio: 1.5,
            children: [
              ProgressStatsCard(
                title: 'Weight',
                value: '68.5',
                unit: 'kg',
                icon: Icons.monitor_weight_outlined,
                onTap: () {},
              ),
              ProgressStatsCard(
                title: 'BMI',
                value: '22.1',
                unit: '',
                icon: Icons.person_outline,
                iconColor: Theme.of(context).colorScheme.secondary,
                onTap: () {},
              ),
              ProgressStatsCard(
                title: 'Body Fat',
                value: '18.2',
                unit: '%',
                icon: Icons.water_drop_outlined,
                iconColor: Theme.of(context).colorScheme.tertiary,
                onTap: () {},
              ),
              ProgressStatsCard(
                title: 'Muscle Mass',
                value: '52.3',
                unit: 'kg',
                icon: Icons.fitness_center_outlined,
                iconColor: Colors.redAccent,
                onTap: () {},
              ),
            ],
          ),

          SizedBox(height: SizeConfig.mediumPadding),

          // Weight chart
          ProgressChart(
            title: 'Weight Progress',
            spots: [
              FlSpot(0, 70.2),
              FlSpot(1, 69.8),
              FlSpot(2, 69.5),
              FlSpot(3, 69.1),
              FlSpot(4, 68.9),
              FlSpot(5, 68.7),
              FlSpot(6, 68.5),
            ],
            bottomTitles: _lastSevenDays,
          ),

          SizedBox(height: SizeConfig.mediumPadding),

          // Workout chart
          ProgressChart(
            title: 'Workout Duration',
            spots: [
              FlSpot(0, 45),
              FlSpot(1, 30),
              FlSpot(2, 60),
              FlSpot(3, 45),
              FlSpot(4, 50),
              FlSpot(5, 35),
              FlSpot(6, 55),
            ],
            lineColor: Theme.of(context).colorScheme.secondary,
            bottomTitles: _lastSevenDays,
          ),

          SizedBox(height: SizeConfig.mediumPadding),

          // Calories chart
          ProgressChart(
            title: 'Calories Burned',
            spots: [
              FlSpot(0, 320),
              FlSpot(1, 250),
              FlSpot(2, 400),
              FlSpot(3, 350),
              FlSpot(4, 380),
              FlSpot(5, 240),
              FlSpot(6, 410),
            ],
            lineColor: Theme.of(context).colorScheme.tertiary,
            bottomTitles: _lastSevenDays,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTab() {
    // Placeholder for monthly tab
    final List<String> lastFourWeeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Month\'s Stats',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: SizeConfig.defaultPadding),

          // Dashboard stats summary for the month
          DashboardStats(
            completedWorkouts: 20,
            burnedCalories: 5100,
            activeMinutes: 1240,
          ),

          SizedBox(height: SizeConfig.mediumPadding),

          // Weight chart for the month
          ProgressChart(
            title: 'Weight Progress',
            spots: [
              FlSpot(0, 71.5),
              FlSpot(1, 70.8),
              FlSpot(2, 69.7),
              FlSpot(3, 68.5),
            ],
            bottomTitles: lastFourWeeks,
          ),

          SizedBox(height: SizeConfig.mediumPadding),

          // Workout chart for the month
          ProgressChart(
            title: 'Weekly Workout Duration',
            spots: [
              FlSpot(0, 210),
              FlSpot(1, 180),
              FlSpot(2, 230),
              FlSpot(3, 235),
            ],
            lineColor: Theme.of(context).colorScheme.secondary,
            bottomTitles: lastFourWeeks,
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyTab() {
    // Placeholder for yearly tab
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final List<String> lastSixMonths = months.sublist(DateTime.now().month - 6 >= 0 ? DateTime.now().month - 6 : 0, DateTime.now().month);

    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Year\'s Stats',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: SizeConfig.defaultPadding),

          // Dashboard stats summary for the year
          DashboardStats(
            completedWorkouts: 120,
            burnedCalories: 32000,
            activeMinutes: 7200,
          ),

          SizedBox(height: SizeConfig.mediumPadding),

          // Weight chart for the year
          ProgressChart(
            title: 'Weight Progress',
            spots: [
              FlSpot(0, 75),
              FlSpot(1, 74),
              FlSpot(2, 72.5),
              FlSpot(3, 71),
              FlSpot(4, 69.5),
              FlSpot(5, 68.5),
            ],
            bottomTitles: lastSixMonths,
          ),
        ],
      ),
    );
  }

  void _showAddWorkoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Workout Result'),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddMeasurementsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: SizeConfig.defaultPadding,
          right: SizeConfig.defaultPadding,
          top: SizeConfig.defaultPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Measurements',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: SizeConfig.defaultPadding),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'Enter your weight',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: SizeConfig.defaultPadding),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Body Fat (%)',
                hintText: 'Enter your body fat percentage',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: SizeConfig.mediumPadding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save measurements
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ),
            SizedBox(height: SizeConfig.defaultPadding),
          ],
        ),
      ),
    );
  }

  void _showAddPhotoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Progress Photo'),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}