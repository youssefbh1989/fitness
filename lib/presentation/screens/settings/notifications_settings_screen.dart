
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../blocs/settings/settings_bloc.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification settings updated'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            final settings = state.settings;
            
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(context, 'General Notifications'),
                _buildSwitch(
                  context: context,
                  title: 'Enable All Notifications',
                  value: settings.notificationsEnabled,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(
                      UpdateSettingsEvent(
                        settings: settings.copyWith(notificationsEnabled: value),
                      ),
                    );
                  },
                ),
                const Divider(),
                
                _buildHeader(context, 'Workout Reminders'),
                _buildSwitch(
                  context: context,
                  title: 'Workout Reminders',
                  subtitle: 'Receive reminders for scheduled workouts',
                  value: settings.workoutReminders,
                  onChanged: settings.notificationsEnabled
                      ? (value) {
                          context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(
                              settings: settings.copyWith(workoutReminders: value),
                            ),
                          );
                        }
                      : null,
                ),
                if (settings.notificationsEnabled && settings.workoutReminders)
                  _buildListTile(
                    context: context,
                    title: 'Reminder Time',
                    subtitle: settings.workoutReminderTime,
                    trailing: const Icon(Icons.access_time),
                    onTap: () {
                      _showTimePickerDialog(
                        context,
                        settings.workoutReminderTime,
                        (time) {
                          context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(
                              settings: settings.copyWith(workoutReminderTime: time),
                            ),
                          );
                        },
                      );
                    },
                  ),
                const Divider(),
                
                _buildHeader(context, 'Activity Updates'),
                _buildSwitch(
                  context: context,
                  title: 'Goal Achievements',
                  subtitle: 'Notify when you reach fitness goals',
                  value: settings.goalNotifications,
                  onChanged: settings.notificationsEnabled
                      ? (value) {
                          context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(
                              settings: settings.copyWith(goalNotifications: value),
                            ),
                          );
                        }
                      : null,
                ),
                _buildSwitch(
                  context: context,
                  title: 'Friend Activity',
                  subtitle: 'Updates about friends' workouts and achievements',
                  value: settings.friendActivityNotifications,
                  onChanged: settings.notificationsEnabled
                      ? (value) {
                          context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(
                              settings: settings.copyWith(friendActivityNotifications: value),
                            ),
                          );
                        }
                      : null,
                ),
                const Divider(),
                
                _buildHeader(context, 'App Updates'),
                _buildSwitch(
                  context: context,
                  title: 'New Features',
                  subtitle: 'Be notified about new app features',
                  value: settings.newFeatureNotifications,
                  onChanged: settings.notificationsEnabled
                      ? (value) {
                          context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(
                              settings: settings.copyWith(newFeatureNotifications: value),
                            ),
                          );
                        }
                      : null,
                ),
                _buildSwitch(
                  context: context,
                  title: 'Tips & Offers',
                  subtitle: 'Receive fitness tips and special offers',
                  value: settings.marketingNotifications,
                  onChanged: settings.notificationsEnabled
                      ? (value) {
                          context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(
                              settings: settings.copyWith(marketingNotifications: value),
                            ),
                          );
                        }
                      : null,
                ),
                const Divider(),
                
                _buildHeader(context, 'Notification Sound'),
                _buildListTile(
                  context: context,
                  title: 'Sound',
                  subtitle: settings.notificationSound,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: settings.notificationsEnabled
                      ? () {
                          _showSoundSelectionDialog(
                            context,
                            settings.notificationSound,
                            (sound) {
                              context.read<SettingsBloc>().add(
                                UpdateSettingsEvent(
                                  settings: settings.copyWith(notificationSound: sound),
                                ),
                              );
                            },
                          );
                        }
                      : null,
                ),
                _buildSwitch(
                  context: context,
                  title: 'Vibration',
                  value: settings.notificationVibration,
                  onChanged: settings.notificationsEnabled
                      ? (value) {
                          context.read<SettingsBloc>().add(
                            UpdateSettingsEvent(
                              settings: settings.copyWith(notificationVibration: value),
                            ),
                          );
                        }
                      : null,
                ),
                const SizedBox(height: 40),
                
                ElevatedButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(
                      ResetNotificationSettingsEvent(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black87,
                  ),
                  child: const Text('Reset to Default Settings'),
                ),
              ],
            );
          }
          
          return const Center(child: Text('No settings available'));
        },
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSwitch({
    required BuildContext context,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
      enabled: onChanged != null,
      onTap: onChanged != null
          ? () {
              onChanged(!value);
            }
          : null,
    );
  }
  
  Widget _buildListTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      enabled: onTap != null,
      onTap: onTap,
    );
  }
  
  void _showTimePickerDialog(
    BuildContext context,
    String currentTime,
    Function(String) onTimeSelected,
  ) {
    // Parse current time string to TimeOfDay
    TimeOfDay initialTime;
    try {
      final timeParts = currentTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      initialTime = TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      initialTime = TimeOfDay.now();
    }
    
    showTimePicker(
      context: context,
      initialTime: initialTime,
    ).then((timeOfDay) {
      if (timeOfDay != null) {
        final hour = timeOfDay.hour.toString().padLeft(2, '0');
        final minute = timeOfDay.minute.toString().padLeft(2, '0');
        onTimeSelected('$hour:$minute');
      }
    });
  }
  
  void _showSoundSelectionDialog(
    BuildContext context,
    String currentSound,
    Function(String) onSoundSelected,
  ) {
    final sounds = [
      'Default',
      'Chime',
      'Bell',
      'Notification 1',
      'Notification 2',
      'None',
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Notification Sound'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sounds.length,
            itemBuilder: (context, index) {
              final sound = sounds[index];
              return ListTile(
                title: Text(sound),
                trailing: sound == currentSound
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onSoundSelected(sound);
                },
              );
            },
          ),
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../widgets/custom_app_bar.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _pushNotifications = true;
  bool _reminderNotifications = true;
  bool _achievementNotifications = true;
  
  // Workout reminder times
  final Map<String, TimeOfDay?> _workoutReminders = {
    'Monday': TimeOfDay(hour: 7, minute: 0),
    'Tuesday': null,
    'Wednesday': TimeOfDay(hour: 7, minute: 0),
    'Thursday': null,
    'Friday': TimeOfDay(hour: 7, minute: 0),
    'Saturday': TimeOfDay(hour: 9, minute: 0),
    'Sunday': null,
  };

  @override
  void initState() {
    super.initState();
    // Load current settings
    final state = context.read<SettingsBloc>().state;
    if (state is SettingsLoaded) {
      setState(() {
        _notificationsEnabled = state.settings.notificationsEnabled;
        _pushNotifications = state.settings.pushNotifications;
        _reminderNotifications = state.settings.reminderNotifications;
        _achievementNotifications = state.settings.achievementNotifications;
      });
    }
  }

  void _saveSettings() {
    if (context.read<SettingsBloc>().state is SettingsLoaded) {
      final currentSettings = (context.read<SettingsBloc>().state as SettingsLoaded).settings;
      
      final updatedSettings = currentSettings.copyWith(
        notificationsEnabled: _notificationsEnabled,
        pushNotifications: _pushNotifications,
        reminderNotifications: _reminderNotifications,
        achievementNotifications: _achievementNotifications,
      );
      
      context.read<SettingsBloc>().add(UpdateSettingsEvent(settings: updatedSettings));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notification Settings',
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
              'Enable Notifications',
              'Turn on/off all notifications',
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value),
            ),
            if (_notificationsEnabled) ...[
              SizedBox(height: SizeConfig.screenHeight! * 0.03),
              Text(
                'Notification Types',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.01),
              _buildSwitchSetting(
                'Push Notifications',
                'Receive general app notifications',
                _pushNotifications,
                (value) => setState(() => _pushNotifications = value),
              ),
              _buildSwitchSetting(
                'Workout Reminders',
                'Get reminded of scheduled workouts',
                _reminderNotifications,
                (value) => setState(() => _reminderNotifications = value),
              ),
              _buildSwitchSetting(
                'Achievement Alerts',
                'Be notified when you reach new milestones',
                _achievementNotifications,
                (value) => setState(() => _achievementNotifications = value),
              ),
              if (_reminderNotifications) ...[
                SizedBox(height: SizeConfig.screenHeight! * 0.03),
                Text(
                  'Workout Reminder Schedule',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.01),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _workoutReminders.length,
                    separatorBuilder: (context, index) => Divider(
                      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final day = _workoutReminders.keys.elementAt(index);
                      final time = _workoutReminders[day];
                      return ListTile(
                        title: Text(day),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              time == null ? 'Not set' : '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: time == null ? Colors.grey : null,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (!_reminderNotifications) return;
                          
                          final TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: time ?? TimeOfDay.now(),
                          );
                          
                          if (selectedTime != null) {
                            setState(() {
                              _workoutReminders[day] = selectedTime;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
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
            if (_notificationsEnabled) ...[
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    // Test notification
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Test notification sent'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Send Test Notification'),
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
                Icons.notifications,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Notification Preferences',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Control how and when you receive notifications. Stay motivated with timely reminders for your workouts and achievements.',
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
