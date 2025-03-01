import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/workout/workout_bloc.dart';
import '../../blocs/workout/workout_event.dart'; 
import '../../blocs/nutrition/nutrition_bloc.dart';
import '../../blocs/nutrition/nutrition_event.dart'; 
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../nutrition/nutrition_list_screen.dart';
import '../workout_detail/workout_detail_screen.dart';
import '../settings/settings_screen.dart';
import '../progress/progress_tracker_screen.dart';
import '../workout/workout_categories_screen.dart'; 
import '../../blocs/user/user_bloc.dart'; // Added UserBloc import
import '../../widgets/notification_badge.dart'; // Added import for NotificationBadge
import '../community/community_screen.dart'; // Added import for CommunityScreen


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const WorkoutCategoriesScreen(),
    const CommunityScreen(), // Added CommunityScreen
    const NutritionListScreen(),
    const ProgressTrackerScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Workouts',
    'Community', // Added Community
    'Nutrition',
    'Progress',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<WorkoutBloc>().add(GetWorkoutsEvent());
    context.read<NutritionBloc>().add(GetNutritionPlansEvent());
    context.read<UserBloc>().add(const GetUserProfile()); // Added UserBloc initialization
  }

  Widget _buildAppBarTitle() {
    return Text(_titles[_currentIndex]); // Added this function for clarity
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          const NotificationBadge(),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: _currentIndex == 1 || _currentIndex == 2 || _currentIndex == 3
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(
                  context, 
                  _currentIndex == 1 ? '/workout-search' : (_currentIndex == 2 ? '/community-search' : '/nutrition-search')
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.search, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Load appropriate data based on the selected tab
          if (index == 1) { // Workouts tab
            context.read<WorkoutBloc>().add(const GetWorkoutCategoriesEvent());
          } else if (index == 2) { // Community tab
            // Add community bloc event here if needed
          } else if (index == 3) { // Nutrition tab
            context.read<NutritionBloc>().add(const GetNutritionGoalsEvent());
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            activeIcon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}