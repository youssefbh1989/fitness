
import 'package:flutter/material.dart';
import '../../../core/utils/size_config.dart';
import '../../widgets/custom_app_bar.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Help & Support',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            SizedBox(height: SizeConfig.screenHeight! * 0.03),
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            _buildFAQItem(
              context,
              'How do I track my workout progress?',
              'You can track your workout progress by navigating to the Workouts tab and selecting a workout. After completing the workout, tap on "Log Workout" to save your stats. View your progress over time in the Profile tab under "Workout History".',
            ),
            _buildFAQItem(
              context,
              'Can I create custom workouts?',
              'Yes! Go to the Workouts tab and tap the "+" button at the bottom. From there, you can create your own custom workout by selecting exercises, setting reps, sets, and rest periods.',
            ),
            _buildFAQItem(
              context,
              'How do I sync my data across devices?',
              'To sync your data, make sure you have created an account and are logged in. Go to Settings > Sync Settings and enable "Auto Sync". Your data will be automatically synced to the cloud and available on all your devices.',
            ),
            _buildFAQItem(
              context,
              'How can I track my nutrition?',
              'Go to the Nutrition tab to log your meals and track your calorie intake. You can also plan meals in advance by tapping on "Meal Planning" and set nutrition goals in Settings > Goals.',
            ),
            _buildFAQItem(
              context,
              'What should I do if I encounter technical issues?',
              'If you encounter any technical issues, try restarting the app or your device. You can also clear app cache in your device settings. If the issue persists, contact our support team using the "Contact Support" button below.',
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.04),
            Text(
              'Contact Support',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            _buildContactOption(
              context,
              'Email Support',
              'Get help via email within 24 hours',
              Icons.email,
              () {
                // Launch email app
              },
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            _buildContactOption(
              context,
              'Live Chat',
              'Chat with our support team now',
              Icons.chat_bubble,
              () {
                // Launch chat interface
              },
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            _buildContactOption(
              context,
              'Call Us',
              'Available Mon-Fri, 9AM to 5PM EST',
              Icons.phone,
              () {
                // Launch phone app
              },
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.04),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.blueGrey.shade800 : Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blueGrey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('App Version', '1.0.0'),
                  _buildInfoRow('Build Number', '100'),
                  _buildInfoRow('Device', 'iPhone 13 Pro'),
                  _buildInfoRow('OS Version', 'iOS 15.4'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Copy debug info to clipboard
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Debug info copied to clipboard'),
                          ),
                        );
                      },
                      child: const Text('Copy Debug Info'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                Icons.support_agent,
                color: Colors.white,
                size: 36,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need Assistance?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'We\'re here to help!',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Check out our FAQs below or contact our support team for personalized assistance with any issues you\'re experiencing.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
