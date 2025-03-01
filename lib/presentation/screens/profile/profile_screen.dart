import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/size_config.dart';
import '../../../core/constants/assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(SizeConfig.defaultPadding),
          child: Column(
            children: [
              _buildProfileHeader(context),
              SizedBox(height: SizeConfig.largePadding),
              _buildStatsSection(context),
              SizedBox(height: SizeConfig.largePadding),
              _buildProgressSection(context),
              SizedBox(height: SizeConfig.largePadding),
              _buildOptionsSection(context),
              SizedBox(height: SizeConfig.largePadding),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Track Your Progress',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: SizeConfig.defaultPadding),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/add_progress',
              arguments: {'userId': 'current_user_id'},
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultPadding,
              vertical: SizeConfig.defaultPadding,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 24),
              SizedBox(width: SizeConfig.smallPadding),
              Text('Add Today\'s Progress'),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildProfileHeader(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          final user = state.user;
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth! * 0.05,
                  vertical: SizeConfig.screenHeight! * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRouter.editProfileRoute);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.02),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(Assets.profilePlaceholder),
                            ),
                          ),
                          SizedBox(width: SizeConfig.screenWidth! * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: SizeConfig.screenHeight! * 0.005),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: SizeConfig.screenHeight! * 0.01),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Text(
                                    'Pro Member',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Failed to load profile'));
        }
      },
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.directions_run,
                title: 'Workouts',
                value: '28',
                color: Colors.blue,
              ),
              _buildStatItem(
                icon: Icons.local_fire_department,
                title: 'Calories',
                value: '12.5k',
                color: Colors.orange,
              ),
              _buildStatItem(
                icon: Icons.timer,
                title: 'Minutes',
                value: '860',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: SizeConfig.screenWidth! * 0.27,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.005),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(BuildContext context) {
    final menuItems = [
      {'icon': Icons.person, 'title': 'Personal Information'},
      {'icon': Icons.notifications, 'title': 'Notifications'},
      {'icon': Icons.fitness_center, 'title': 'My Workouts'},
      {'icon': Icons.restaurant_menu, 'title': 'My Nutrition Plans'},
      {'icon': Icons.emoji_events, 'title': 'Achievements'},
      {'icon': Icons.settings, 'title': 'Settings'},
      {'icon': Icons.help, 'title': 'Help & Support'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Options',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    item['title'] as String,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                  onTap: () {
                    if (item['title'] == 'Settings') {
                      Navigator.pushNamed(context, AppRouter.settingsRoute);
                    } else if (item['title'] == 'Achievements') {
                      Navigator.pushNamed(context, AppRouter.achievementsRoute); // Placeholder navigation
                    }
                    // Navigate to corresponding screen for other options
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.05),
      child: ElevatedButton.icon(
        onPressed: () {
          // Show confirmation dialog
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
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              ],
            ),
          );
        },
        icon: const Icon(
          Icons.logout,
          color: Colors.red,
        ),
        label: const Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.1),
          foregroundColor: Colors.red,
          minimumSize: Size(SizeConfig.screenWidth!, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}