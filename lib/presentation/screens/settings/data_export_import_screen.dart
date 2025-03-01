
import 'package:flutter/material.dart';
import '../../../core/utils/size_config.dart';
import '../../widgets/custom_app_bar.dart';

class DataExportImportScreen extends StatefulWidget {
  const DataExportImportScreen({Key? key}) : super(key: key);

  @override
  State<DataExportImportScreen> createState() => _DataExportImportScreenState();
}

class _DataExportImportScreenState extends State<DataExportImportScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  String? _lastExportDate;
  final List<String> _dataTypes = [
    'Workouts',
    'Nutrition',
    'Measurements',
    'Goals',
    'Achievements',
  ];

  final Map<String, bool> _selectedDataTypes = {
    'Workouts': true,
    'Nutrition': true,
    'Measurements': true,
    'Goals': true,
    'Achievements': true,
  };

  @override
  void initState() {
    super.initState();
    // Simulate fetching last export date
    _lastExportDate = 'March 20, 2023';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Export & Import',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(isDarkMode),
            SizedBox(height: SizeConfig.screenHeight! * 0.03),
            Text(
              'Export Data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01),
            Text(
              'Select the data you want to export',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            ..._dataTypes.map((type) => _buildCheckboxItem(type)),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isExporting || !_selectedDataTypes.values.contains(true)
                        ? null
                        : _exportData,
                    icon: _isExporting
                        ? Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(Icons.cloud_upload),
                    label: Text(_isExporting ? 'Exporting...' : 'Export Data'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            if (_lastExportDate != null) ...[
              SizedBox(height: SizeConfig.screenHeight! * 0.01),
              Center(
                child: Text(
                  'Last export: $_lastExportDate',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
            SizedBox(height: SizeConfig.screenHeight! * 0.04),
            Text(
              'Import Data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01),
            Text(
              'Import your fitness data from a backup file',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            _buildImportOption(
              'From Cloud Backup',
              'Import the latest data from your cloud account',
              Icons.cloud_download,
              _importFromCloud,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            _buildImportOption(
              'From File',
              'Import from a locally stored backup file',
              Icons.folder_open,
              _importFromFile,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.04),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.orange.shade900.withOpacity(0.2) : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Important Note',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Importing data will overwrite any existing data. Make sure to export your current data first to avoid losing information.',
                    style: TextStyle(
                      color: isDarkMode ? Colors.orange.shade100 : Colors.orange.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.storage,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Data Management',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Export your fitness data for backup or transfer it to another device. You can import previously exported data anytime.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String type) {
    return CheckboxListTile(
      title: Text(type),
      value: _selectedDataTypes[type],
      onChanged: (bool? value) {
        setState(() {
          _selectedDataTypes[type] = value!;
        });
      },
      activeColor: Theme.of(context).primaryColor,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  void _exportData() {
    setState(() {
      _isExporting = true;
    });

    // Simulate export process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isExporting = false;
        _lastExportDate = 'May 15, 2023'; // Update with current date
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  Widget _buildImportOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: _isImporting ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }

  void _importFromCloud() {
    setState(() {
      _isImporting = true;
    });

    // Simulate import process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isImporting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data imported successfully from cloud'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _importFromFile() {
    setState(() {
      _isImporting = true;
    });

    // Simulate file picker and import process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isImporting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data imported successfully from file'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
