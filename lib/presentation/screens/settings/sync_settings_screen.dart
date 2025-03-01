
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../widgets/custom_app_bar.dart';

class SyncSettingsScreen extends StatefulWidget {
  const SyncSettingsScreen({Key? key}) : super(key: key);

  @override
  State<SyncSettingsScreen> createState() => _SyncSettingsScreenState();
}

class _SyncSettingsScreenState extends State<SyncSettingsScreen> {
  bool _autoSyncEnabled = true;
  bool _syncOverWifiOnly = true;
  bool _syncWorkouts = true;
  bool _syncNutrition = true;
  bool _syncMeasurements = true;
  String _syncFrequency = 'Daily';
  
  final List<String> _syncFrequencies = ['Hourly', 'Daily', 'Weekly'];

  @override
  void initState() {
    super.initState();
    // Load current settings
    final state = context.read<SettingsBloc>().state;
    if (state is SettingsLoaded) {
      setState(() {
        _autoSyncEnabled = state.settings.autoSync;
        _syncOverWifiOnly = state.settings.syncOnWifiOnly;
        _syncWorkouts = state.settings.syncWorkouts;
        _syncNutrition = state.settings.syncNutrition;
        _syncMeasurements = state.settings.syncMeasurements;
        _syncFrequency = state.settings.syncFrequency;
      });
    }
  }

  void _saveSettings() {
    final event = UpdateSettingsEvent(
      settings: Settings(
        darkMode: context.read<SettingsBloc>().state is SettingsLoaded
            ? (context.read<SettingsBloc>().state as SettingsLoaded).settings.darkMode
            : false,
        notificationsEnabled: context.read<SettingsBloc>().state is SettingsLoaded
            ? (context.read<SettingsBloc>().state as SettingsLoaded).settings.notificationsEnabled
            : true,
        autoSync: _autoSyncEnabled,
        syncOnWifiOnly: _syncOverWifiOnly,
        syncWorkouts: _syncWorkouts,
        syncNutrition: _syncNutrition,
        syncMeasurements: _syncMeasurements,
        syncFrequency: _syncFrequency,
      ),
    );
    
    context.read<SettingsBloc>().add(event);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sync settings saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sync Settings',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(isDarkMode),
            SizedBox(height: SizeConfig.screenHeight! * 0.03),
            _buildSwitchSetting(
              'Auto Sync',
              'Automatically sync your data with the cloud',
              _autoSyncEnabled,
              (value) => setState(() => _autoSyncEnabled = value),
            ),
            if (_autoSyncEnabled) ...[
              _buildSwitchSetting(
                'Sync Over Wi-Fi Only',
                'Sync only when connected to Wi-Fi network',
                _syncOverWifiOnly,
                (value) => setState(() => _syncOverWifiOnly = value),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              Text(
                'Sync Frequency',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.01),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _syncFrequency,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    dropdownColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                    items: _syncFrequencies.map((String frequency) {
                      return DropdownMenuItem<String>(
                        value: frequency,
                        child: Text(frequency),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _syncFrequency = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.03),
              Text(
                'What to Sync',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.01),
              _buildSwitchSetting(
                'Workouts',
                'Sync your workout history and progress',
                _syncWorkouts,
                (value) => setState(() => _syncWorkouts = value),
              ),
              _buildSwitchSetting(
                'Nutrition',
                'Sync your meal plans and nutrition logs',
                _syncNutrition,
                (value) => setState(() => _syncNutrition = value),
              ),
              _buildSwitchSetting(
                'Body Measurements',
                'Sync your body measurements history',
                _syncMeasurements,
                (value) => setState(() => _syncMeasurements = value),
              ),
            ],
            SizedBox(height: SizeConfig.screenHeight! * 0.05),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text('Save Settings'),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            if (_autoSyncEnabled) ...[
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    // Trigger manual sync
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Manual sync initiated'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync Now'),
                ),
              ),
            ],
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
                Icons.cloud_sync,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Cloud Synchronization',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Keep your fitness data synced across all your devices. Enable auto-sync to ensure your progress is always up to date.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSwitchSetting(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
