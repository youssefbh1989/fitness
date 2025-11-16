import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';

// Assuming LoadingWidget is defined elsewhere and imported
// For demonstration, let's define a placeholder LoadingWidget here:
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  String _unitSystem = 'Metric';
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _darkMode = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const LoadingWidget();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Account'),
                _buildAccountSettings(),
                _buildSectionTitle('Preferences'),
                _buildPreferencesSettings(),
                _buildSectionTitle('Notifications'),
                _buildNotificationSettings(),
                _buildSectionTitle('Privacy'),
                _buildPrivacySettings(),
                _buildSectionTitle('Support'),
                _buildSupportSettings(),
                _buildSectionTitle('About'),
                _buildAboutSettings(),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => _showLogoutDialog(),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () => _showDeleteAccountDialog(),
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'FitBody v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        _buildSettingItem(
          title: 'Personal Information',
          subtitle: 'Update your profile details',
          icon: Icons.person,
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        _buildSettingItem(
          title: 'Email & Password',
          subtitle: 'Change login credentials',
          icon: Icons.lock,
          onTap: () {},
        ),
        _buildSettingItem(
          title: 'Connected Accounts',
          subtitle: 'Manage your linked services',
          icon: Icons.link,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPreferencesSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: Text(_darkMode ? 'On' : 'Off'),
          secondary: const Icon(Icons.dark_mode),
          value: _darkMode,
          onChanged: (value) {
            setState(() {
              _darkMode = value;
            });
          },
        ),
        ListTile(
          title: const Text('Units'),
          subtitle: Text(_unitSystem),
          leading: const Icon(Icons.straighten),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showUnitSystemDialog(),
        ),
        ListTile(
          title: const Text('Language'),
          subtitle: Text(_language),
          leading: const Icon(Icons.language),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLanguageDialog(),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: Text(_notifications ? 'Enabled' : 'Disabled'),
          secondary: const Icon(Icons.notifications),
          value: _notifications,
          onChanged: (value) {
            setState(() {
              _notifications = value;
            });
          },
        ),
        _buildSettingItem(
          title: 'Notification Preferences',
          subtitle: 'Choose what to be notified about',
          icon: Icons.tune,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return Column(
      children: [
        _buildSettingItem(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          icon: Icons.privacy_tip,
          onTap: () {},
        ),
        _buildSettingItem(
          title: 'Data Collection',
          subtitle: 'Manage data collection settings',
          icon: Icons.data_usage,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSupportSettings() {
    return Column(
      children: [
        _buildSettingItem(
          title: 'Help Center',
          subtitle: 'Get help with using the app',
          icon: Icons.help,
          onTap: () {},
        ),
        _buildSettingItem(
          title: 'Report a Problem',
          subtitle: 'Let us know about any issues',
          icon: Icons.bug_report,
          onTap: () {},
        ),
        _buildSettingItem(
          title: 'Contact Us',
          subtitle: 'Reach out to our support team',
          icon: Icons.email,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAboutSettings() {
    return Column(
      children: [
        _buildSettingItem(
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          icon: Icons.description,
          onTap: () {},
        ),
        _buildSettingItem(
          title: 'Licenses',
          subtitle: 'View open source licenses',
          icon: Icons.card_membership,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showUnitSystemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Metric (kg, cm)'),
              value: 'Metric',
              groupValue: _unitSystem,
              onChanged: (value) {
                setState(() {
                  _unitSystem = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Imperial (lb, ft)'),
              value: 'Imperial',
              groupValue: _unitSystem,
              onChanged: (value) {
                setState(() {
                  _unitSystem = value!;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Spanish'),
              value: 'Spanish',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('French'),
              value: 'French',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
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
              context.read<UserBloc>().add(LogOutEvent());
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}