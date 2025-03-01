
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
