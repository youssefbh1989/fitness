
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/size_config.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/progress_chart_widget.dart';

class BodyMeasurementsScreen extends StatefulWidget {
  const BodyMeasurementsScreen({Key? key}) : super(key: key);

  @override
  State<BodyMeasurementsScreen> createState() => _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends State<BodyMeasurementsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _activeTimeRange = '1M'; // Default 1 month view
  final List<String> _timeRanges = ['1W', '1M', '3M', '6M', '1Y', 'All'];
  
  // Sample measurements data
  final Map<String, List<Map<String, dynamic>>> _measurementsData = {
    'Weight': [
      {'date': DateTime.now().subtract(const Duration(days: 30)), 'value': 75.5},
      {'date': DateTime.now().subtract(const Duration(days: 25)), 'value': 75.2},
      {'date': DateTime.now().subtract(const Duration(days: 20)), 'value': 74.8},
      {'date': DateTime.now().subtract(const Duration(days: 15)), 'value': 74.3},
      {'date': DateTime.now().subtract(const Duration(days: 10)), 'value': 73.9},
      {'date': DateTime.now().subtract(const Duration(days: 5)), 'value': 73.5},
      {'date': DateTime.now(), 'value': 73.2},
    ],
    'Body Fat': [
      {'date': DateTime.now().subtract(const Duration(days: 30)), 'value': 18.5},
      {'date': DateTime.now().subtract(const Duration(days: 25)), 'value': 18.3},
      {'date': DateTime.now().subtract(const Duration(days: 20)), 'value': 18.1},
      {'date': DateTime.now().subtract(const Duration(days: 15)), 'value': 17.8},
      {'date': DateTime.now().subtract(const Duration(days: 10)), 'value': 17.5},
      {'date': DateTime.now().subtract(const Duration(days: 5)), 'value': 17.2},
      {'date': DateTime.now(), 'value': 17.0},
    ],
    'Chest': [
      {'date': DateTime.now().subtract(const Duration(days: 30)), 'value': 95.0},
      {'date': DateTime.now().subtract(const Duration(days: 20)), 'value': 95.5},
      {'date': DateTime.now().subtract(const Duration(days: 10)), 'value': 96.0},
      {'date': DateTime.now(), 'value': 96.5},
    ],
    'Waist': [
      {'date': DateTime.now().subtract(const Duration(days: 30)), 'value': 85.0},
      {'date': DateTime.now().subtract(const Duration(days: 20)), 'value': 84.5},
      {'date': DateTime.now().subtract(const Duration(days: 10)), 'value': 84.0},
      {'date': DateTime.now(), 'value': 83.5},
    ],
    'Hips': [
      {'date': DateTime.now().subtract(const Duration(days: 30)), 'value': 98.0},
      {'date': DateTime.now().subtract(const Duration(days: 20)), 'value': 97.5},
      {'date': DateTime.now().subtract(const Duration(days: 10)), 'value': 97.0},
      {'date': DateTime.now(), 'value': 96.5},
    ],
    'Arms': [
      {'date': DateTime.now().subtract(const Duration(days: 30)), 'value': 35.0},
      {'date': DateTime.now().subtract(const Duration(days: 20)), 'value': 35.2},
      {'date': DateTime.now().subtract(const Duration(days: 10)), 'value': 35.5},
      {'date': DateTime.now(), 'value': 35.8},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _measurementsData.keys.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Body Measurements',
        showBackButton: true,
      ),
      body: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: _measurementsData.keys.map((title) => Tab(text: title)).toList(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenWidth! * 0.05,
              vertical: SizeConfig.screenHeight! * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress Chart',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _buildTimeRangeSelector(),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _measurementsData.keys.map((title) {
                return _buildMeasurementTab(title, _measurementsData[title]!, isDarkMode);
              }).toList(),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.05),
            child: ElevatedButton.icon(
              onPressed: () => _showAddMeasurementDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Measurement'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _timeRanges.map((range) {
          bool isActive = range == _activeTimeRange;
          return GestureDetector(
            onTap: () {
              setState(() {
                _activeTimeRange = range;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? Theme.of(context).primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                range,
                style: TextStyle(
                  color: isActive ? Colors.white : Theme.of(context).primaryColor,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMeasurementTab(String title, List<Map<String, dynamic>> data, bool isDarkMode) {
    // Get the latest measurement
    final latestMeasurement = data.isNotEmpty ? data.last : null;
    final previousMeasurement = data.length > 1 ? data[data.length - 2] : null;
    
    // Calculate progress
    double progress = 0;
    String progressIndicator = '';
    if (latestMeasurement != null && previousMeasurement != null) {
      progress = latestMeasurement['value'] - previousMeasurement['value'];
      progressIndicator = progress >= 0 ? '+' : '';
    }
    
    // Units based on measurement type
    String unit = 'cm';
    if (title == 'Weight') {
      unit = 'kg';
    } else if (title == 'Body Fat') {
      unit = '%';
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.05),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          _buildCurrentValueCard(title, latestMeasurement, progressIndicator, progress, unit, isDarkMode),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          Expanded(
            child: ProgressChartWidget(
              data: data,
              title: title,
              timeRange: _activeTimeRange,
              unit: unit,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          _buildHistoryList(data, unit, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildCurrentValueCard(
    String title,
    Map<String, dynamic>? latestMeasurement,
    String progressIndicator,
    double progress,
    String unit,
    bool isDarkMode,
  ) {
    if (latestMeasurement == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No measurements recorded yet',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current $title',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: progress > 0
                      ? Colors.green.withOpacity(0.2)
                      : progress < 0
                          ? Colors.red.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$progressIndicator${progress.abs().toStringAsFixed(1)} $unit',
                  style: TextStyle(
                    color: progress > 0
                        ? Colors.green
                        : progress < 0
                            ? Colors.red
                            : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                latestMeasurement['value'].toString(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: SizeConfig.screenWidth! * 0.01),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  unit,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Last updated: ${DateFormat('MMM d').format(latestMeasurement['date'])}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<Map<String, dynamic>> data, String unit, bool isDarkMode) {
    if (data.isEmpty) {
      return Container();
    }
    
    // Sort data by date in descending order
    final sortedData = List<Map<String, dynamic>>.from(data)
      ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'History',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: sortedData.length > 5 ? 5 : sortedData.length,
            separatorBuilder: (context, index) => Divider(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final measurement = sortedData[index];
              return ListTile(
                title: Text(
                  '${measurement['value']} $unit',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  DateFormat('MMMM d, yyyy').format(measurement['date']),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    // Edit measurement
                  },
                ),
              );
            },
          ),
        ),
        if (sortedData.length > 5) ...[
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          Center(
            child: TextButton(
              onPressed: () {
                // View all history
              },
              child: const Text('View All History'),
            ),
          ),
        ],
      ],
    );
  }

  void _showAddMeasurementDialog(BuildContext context) {
    final measurementType = _measurementsData.keys.toList()[_tabController.index];
    final TextEditingController valueController = TextEditingController();
    final DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $measurementType'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: valueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: measurementType,
                hintText: 'Enter value',
                suffixText: measurementType == 'Weight'
                    ? 'kg'
                    : measurementType == 'Body Fat'
                        ? '%'
                        : 'cm',
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            ListTile(
              title: const Text('Date'),
              subtitle: Text(DateFormat('MMMM d, yyyy').format(selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () {
                // Show date picker
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (valueController.text.isNotEmpty) {
                // Save measurement
                setState(() {
                  _measurementsData[measurementType]!.add({
                    'date': selectedDate,
                    'value': double.parse(valueController.text),
                  });
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
}
