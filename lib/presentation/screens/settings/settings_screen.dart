
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../blocs/auth/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedUnit = 'Metric (kg, cm)';
  
  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
  ];
  
  final List<String> _units = [
    'Metric (kg, cm)',
    'Imperial (lb, ft)',
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
        children: [
          _buildSectionHeader(context, 'Account'),
          _buildAccountSettings(context),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, 'Preferences'),
          _buildPreferencesSettings(context),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, 'Notifications'),
          _buildNotificationSettings(context),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, 'Privacy'),
          _buildPrivacySettings(context),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, 'About'),
          _buildAboutSettings(context),
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            'Personal Information',
            Icons.person,
            onTap: () {
              Navigator.pushNamed(context, '/profile/edit');
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            'Change Password',
            Icons.lock,
            onTap: () {
              Navigator.pushNamed(context, '/change-password');
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            'Linked Accounts',
            Icons.link,
            onTap: () {
              Navigator.pushNamed(context, '/linked-accounts');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSettings(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildSwitchSettingsItem(
            context,
            'Dark Mode',
            Icons.dark_mode,
            _darkModeEnabled,
            (value) {
              setState(() {
                _darkModeEnabled = value;
              });
              // TODO: Implement theme switching logic
            },
          ),
          _buildDivider(),
          _buildDropdownSettingsItem(
            context,
            'Language',
            Icons.language,
            _selectedLanguage,
            _languages,
            (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              // TODO: Implement language switching logic
            },
          ),
          _buildDivider(),
          _buildDropdownSettingsItem(
            context,
            'Units',
            Icons.straighten,
            _selectedUnit,
            _units,
            (value) {
              setState(() {
                _selectedUnit = value!;
              });
              // TODO: Implement unit switching logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildSwitchSettingsItem(
            context,
            'Enable Notifications',
            Icons.notifications,
            _notificationsEnabled,
            (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // TODO: Implement notification toggle logic
            },
          ),
          if (_notificationsEnabled) ...[
            _buildDivider(),
            _buildSettingsItem(
              context,
              'Workout Reminders',
              Icons.fitness_center,
              onTap: () {
                Navigator.pushNamed(context, '/notification-settings/workouts');
              },
              trailing: const Text('Daily', style: TextStyle(color: Colors.grey)),
            ),
            _buildDivider(),
            _buildSettingsItem(
              context,
              'Challenge Updates',
              Icons.emoji_events,
              onTap: () {
                Navigator.pushNamed(context, '/notification-settings/challenges');
              },
              trailing: const Text('When new', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivacySettings(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            'Privacy Policy',
            Icons.privacy_tip,
            onTap: () {
              Navigator.pushNamed(context, '/privacy-policy');
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            'Data & Storage',
            Icons.storage,
            onTap: () {
              Navigator.pushNamed(context, '/data-storage');
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            'Delete Account',
            Icons.delete_forever,
            textColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Account'),
                  content: const Text(
                    'Are you sure you want to delete your account? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Implement account deletion logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account deletion requested')),
                        );
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            'App Version',
            Icons.info,
            trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            'Terms of Service',
            Icons.description,
            onTap: () {
              Navigator.pushNamed(context, '/terms-of-service');
            },
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            'Contact Support',
            Icons.support_agent,
            onTap: () {
              Navigator.pushNamed(context, '/support');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon, {
    required VoidCallback onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildDropdownSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
}
