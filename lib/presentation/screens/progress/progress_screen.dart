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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample data for measurements
  final List<Map<String, dynamic>> _measurementsHistory = [
    {
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'weight': 80.5,
      'bodyFat': 18.0,
      'chest': 100.0,
      'waist': 85.0,
      'hips': 102.0,
      'arms': 36.0,
      'thighs': 58.0,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 23)),
      'weight': 79.8,
      'bodyFat': 17.5,
      'chest': 99.5,
      'waist': 84.2,
      'hips': 101.5,
      'arms': 36.2,
      'thighs': 57.8,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 16)),
      'weight': 78.9,
      'bodyFat': 17.0,
      'chest': 99.0,
      'waist': 83.0,
      'hips': 101.0,
      'arms': 36.5,
      'thighs': 57.5,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 9)),
      'weight': 78.2,
      'bodyFat': 16.5,
      'chest': 98.5,
      'waist': 82.0,
      'hips': 100.5,
      'arms': 37.0,
      'thighs': 57.0,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'weight': 77.5,
      'bodyFat': 16.0,
      'chest': 98.0,
      'waist': 81.0,
      'hips': 100.0,
      'arms': 37.5,
      'thighs': 56.5,
    },
  ];

  // Sample data for progress photos
  final List<Map<String, dynamic>> _progressPhotos = [
    {
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'front': 'assets/images/progress_front_1.jpg',
      'side': 'assets/images/progress_side_1.jpg',
      'back': 'assets/images/progress_back_1.jpg',
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'front': 'assets/images/progress_front_2.jpg',
      'side': 'assets/images/progress_side_2.jpg',
      'back': 'assets/images/progress_back_2.jpg',
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 0)),
      'front': 'assets/images/progress_front_3.jpg',
      'side': 'assets/images/progress_side_3.jpg',
      'back': 'assets/images/progress_back_3.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Measurements'),
            Tab(text: 'Photos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMeasurementsTab(),
          _buildPhotosTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddMeasurementsDialog();
          } else {
            _showAddPhotosDialog();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMeasurementsTab() {
    // Calculate the change from first to last measurement
    final firstMeasurement = _measurementsHistory.first;
    final latestMeasurement = _measurementsHistory.last;
    
    final weightChange = latestMeasurement['weight'] - firstMeasurement['weight'];
    final bodyFatChange = latestMeasurement['bodyFat'] - firstMeasurement['bodyFat'];
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(weightChange, bodyFatChange),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildWeightChart(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildLatestMeasurements(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildMeasurementsHistory(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(double weightChange, double bodyFatChange) {
    final weightTrend = weightChange < 0 ? 'Lost' : 'Gained';
    final fatTrend = bodyFatChange < 0 ? 'Lost' : 'Gained';
    
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Weight',
            value: '${_measurementsHistory.last['weight']} kg',
            change: '$weightTrend ${weightChange.abs().toStringAsFixed(1)} kg',
            icon: Icons.monitor_weight,
            color: weightChange < 0 ? Colors.green : Colors.orange,
          ),
        ),
        SizedBox(width: SizeConfig.screenWidth! * 0.05),
        Expanded(
          child: _buildSummaryCard(
            title: 'Body Fat',
            value: '${_measurementsHistory.last['bodyFat']}%',
            change: '$fatTrend ${bodyFatChange.abs().toStringAsFixed(1)}%',
            icon: Icons.show_chart,
            color: bodyFatChange < 0 ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart() {
    // Simplified chart visualization (in a real app, use a chart library)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weight Progress',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _measurementsHistory.asMap().entries.map((entry) {
                final index = entry.key;
                final measurement = entry.value;
                final maxWeight = _measurementsHistory
                    .map((m) => m['weight'] as double)
                    .reduce((a, b) => a > b ? a : b);
                final minWeight = _measurementsHistory
                    .map((m) => m['weight'] as double)
                    .reduce((a, b) => a < b ? a : b);
                
                final range = maxWeight - minWeight;
                final normalizedHeight = range > 0 
                    ? ((measurement['weight'] as double) - minWeight) / range 
                    : 0.5;
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      (measurement['weight'] as double).toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 20,
                      height: 100 * (0.2 + normalizedHeight * 0.8), // Scale to 20%-100% of height
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.7 + 0.3 * normalizedHeight),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MM/dd').format(measurement['date'] as DateTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestMeasurements() {
    final latestMeasurement = _measurementsHistory.last;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Measurements',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('MMM d, yyyy').format(latestMeasurement['date'] as DateTime),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMeasurementItem('Chest', '${latestMeasurement['chest']} cm'),
              ),
              Expanded(
                child: _buildMeasurementItem('Waist', '${latestMeasurement['waist']} cm'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMeasurementItem('Hips', '${latestMeasurement['hips']} cm'),
              ),
              Expanded(
                child: _buildMeasurementItem('Arms', '${latestMeasurement['arms']} cm'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMeasurementItem('Thighs', '${latestMeasurement['thighs']} cm'),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementItem(String label, String value) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMeasurementsHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Date',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      'Weight',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      'Body Fat',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              ..._measurementsHistory.map((measurement) {
                return TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          DateFormat('MMM d, yyyy').format(measurement['date'] as DateTime),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        '${measurement['weight']} kg',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        '${measurement['bodyFat']}%',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosTab() {
    return _progressPhotos.isEmpty
        ? _buildEmptyPhotosState()
        : ListView.builder(
            padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
            itemCount: _progressPhotos.length,
            itemBuilder: (context, index) {
              final photoSet = _progressPhotos[index];
              final date = photoSet['date'] as DateTime;
              return _buildPhotoCard(photoSet, date);
            },
          );
  }

  Widget _buildEmptyPhotosState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_camera,
            size: 64,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Progress Photos Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Add photos to track your visual progress',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddPhotosDialog(),
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Add Your First Photos'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(Map<String, dynamic> photoSet, DateTime date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM d, yyyy').format(date),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show options menu
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: _buildPhotoThumbnail(photoSet['front'], 'Front'),
                ),
                Expanded(
                  child: _buildPhotoThumbnail(photoSet['side'], 'Side'),
                ),
                Expanded(
                  child: _buildPhotoThumbnail(photoSet['back'], 'Back'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Compare with previous photos
                  },
                  icon: const Icon(Icons.compare),
                  label: const Text('Compare'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Share photos
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoThumbnail(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        // Show full-size image
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => const AssetImage('assets/images/placeholder.jpg'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showAddMeasurementsDialog() {
    final TextEditingController weightController = TextEditingController();
    final TextEditingController bodyFatController = TextEditingController();
    final TextEditingController chestController = TextEditingController();
    final TextEditingController waistController = TextEditingController();
    final TextEditingController hipsController = TextEditingController();
    final TextEditingController armsController = TextEditingController();
    final TextEditingController thighsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Measurements'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bodyFatController,
                decoration: const InputDecoration(
                  labelText: 'Body Fat (%)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: chestController,
                decoration: const InputDecoration(
                  labelText: 'Chest (cm)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: waistController,
                decoration: const InputDecoration(
                  labelText: 'Waist (cm)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: hipsController,
                decoration: const InputDecoration(
                  labelText: 'Hips (cm)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: armsController,
                decoration: const InputDecoration(
                  labelText: 'Arms (cm)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: thighsController,
                decoration: const InputDecoration(
                  labelText: 'Thighs (cm)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (weightController.text.isNotEmpty) {
                setState(() {
                  _measurementsHistory.add({
                    'date': DateTime.now(),
                    'weight': double.tryParse(weightController.text) ?? 0.0,
                    'bodyFat': double.tryParse(bodyFatController.text) ?? 0.0,
                    'chest': double.tryParse(chestController.text) ?? 0.0,
                    'waist': double.tryParse(waistController.text) ?? 0.0,
                    'hips': double.tryParse(hipsController.text) ?? 0.0,
                    'arms': double.tryParse(armsController.text) ?? 0.0,
                    'thighs': double.tryParse(thighsController.text) ?? 0.0,
                  });
                  
                  // Sort by date
                  _measurementsHistory.sort((a, b) => 
                    (a['date'] as DateTime).compareTo(b['date'] as DateTime)
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddPhotosDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Progress Photos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take New Photos'),
              onTap: () {
                Navigator.pop(context);
                // Open camera functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Open gallery functionality
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
