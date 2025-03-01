
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../presentation/widgets/custom_app_bar.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _useBiometrics = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(SizeConfig.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: SizeConfig.defaultPadding),
              
              // App Settings
              _buildSettingsCard(
                context,
                title: 'App Preferences',
                children: [
                  _buildSwitchTile(
                    title: 'Dark Mode',
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                        // Implement theme switching logic
                      });
                    },
                  ),
                  _buildLanguageSelector(),
                ],
              ),
              
              SizedBox(height: SizeConfig.defaultPadding),
              
              // Notification Settings
              _buildSettingsCard(
                context,
                title: 'Notifications',
                children: [
                  _buildSwitchTile(
                    title: 'Enable Notifications',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  if (_notificationsEnabled) ...[
                    _buildSwitchTile(
                      title: 'Workout Reminders',
                      value: true,
                      onChanged: (value) {},
                    ),
                    _buildSwitchTile(
                      title: 'Nutrition Reminders',
                      value: true,
                      onChanged: (value) {},
                    ),
                    _buildSwitchTile(
                      title: 'Progress Updates',
                      value: true,
                      onChanged: (value) {},
                    ),
                  ],
                ],
              ),
              
              SizedBox(height: SizeConfig.defaultPadding),
              
              // Security Settings
              _buildSettingsCard(
                context,
                title: 'Security',
                children: [
                  _buildSwitchTile(
                    title: 'Use Biometric Authentication',
                    value: _useBiometrics,
                    onChanged: (value) {
                      setState(() {
                        _useBiometrics = value;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Change Password'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to change password screen
                    },
                  ),
                ],
              ),
              
              SizedBox(height: SizeConfig.defaultPadding),
              
              // Account Settings
              _buildSettingsCard(
                context,
                title: 'Account',
                children: [
                  ListTile(
                    title: Text('Edit Profile'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to edit profile screen
                    },
                  ),
                  ListTile(
                    title: Text('Privacy Policy'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to privacy policy screen
                    },
                  ),
                  ListTile(
                    title: Text('Terms of Service'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to terms of service screen
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
              
              SizedBox(height: SizeConfig.defaultPadding),
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.defaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: SizeConfig.smallPadding),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLanguageSelector() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Language'),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedLanguage = newValue;
            });
          }
        },
        items: <String>['English', 'Spanish', 'French', 'German']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        underline: SizedBox(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UserBloc>().add(LogOutEvent());
              // Navigate to login screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: Text('Log Out'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
