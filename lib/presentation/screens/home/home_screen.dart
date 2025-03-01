import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/size_config.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/workout/workout_bloc.dart';
import '../../widgets/workout_card.dart';
import '../../widgets/challenge_card.dart';
import '../../widgets/article_card.dart';
import '../../widgets/dashboard_stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Selected tab index
  int _selectedIndex = 0;
  
  // List of tab widgets
  final List<Widget> _tabs = [];
  
  @override
  void initState() {
    super.initState();
    // Initialize tabs
    _tabs.addAll([
      _buildDashboardTab(),
      _buildWorkoutsTab(),
      _buildNutritionTab(),
      _buildProfileTab(),
    ]);
    
    // Initialize blocs with proper error handling
    _initializeBlocs();
  }
  
  void _initializeBlocs() {
    try {
      context.read<UserBloc>().add(GetUserProfileEvent());
      context.read<WorkoutBloc>().add(FetchWorkoutsEvent());
    } catch (e) {
      // Handle any initialization errors
      print('Error initializing blocs: $e');
      
      // Retry logic could be added here if needed
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _initializeBlocs();
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final screenWidth = SizeConfig.screenWidth ?? MediaQuery.of(context).size.width;
    final screenHeight = SizeConfig.screenHeight ?? MediaQuery.of(context).size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: _tabs[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
        backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  
  Widget _buildDashboardTab() {
    final screenWidth = SizeConfig.screenWidth ?? MediaQuery.of(context).size.width;
    final screenHeight = SizeConfig.screenHeight ?? MediaQuery.of(context).size.height;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          const DashboardStats(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildDailyGoals(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildRecommendedWorkouts(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildChallenges(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildArticles(),
          SizedBox(height: SizeConfig.screenHeight! * 0.05),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String userName = "Fitness Enthusiast";
        String profileImage = 'assets/images/profile_placeholder.png';
        
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          // Split name and use first part or default if empty
          final nameParts = state.user.name.split(' ');
          userName = nameParts.isNotEmpty ? nameParts[0] : userName;
          
          // Use user profile image if available
          if (state.user.profileImageUrl != null && state.user.profileImageUrl!.isNotEmpty) {
            profileImage = state.user.profileImageUrl!;
          }
        } else if (state is UserError) {
          // Still show the UI but could add a small error indicator
          userName = "Friend";
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userName',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.005),
                Text(
                  'Let\'s check your activity',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Hero(
                  tag: 'profileImage',
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: profileImage.startsWith('assets/')
                        ? AssetImage(profileImage) as ImageProvider
                        : NetworkImage(profileImage),
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading profile image: $exception');
                      // Fall back to placeholder
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDailyGoals() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth! * 0.05,
        vertical: SizeConfig.screenHeight! * 0.02,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Goals',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '3/4',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGoalItem(icon: Icons.directions_run, title: 'Steps', value: '7.5k', target: '8k'),
              _buildGoalItem(icon: Icons.local_fire_department, title: 'Calories', value: '450', target: '500'),
              _buildGoalItem(icon: Icons.access_time_filled, title: 'Minutes', value: '45', target: '60'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem({required IconData icon, required String title, required String value, required String target}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.005),
        RichText(
          text: TextSpan(
            text: value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: '/$target',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedWorkouts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended Workouts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/workouts');
              },
              child: Text(
                'See All',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        BlocBuilder<WorkoutBloc, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutLoading) {
              return SizedBox(
                height: SizeConfig.screenHeight! * 0.20,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (state is WorkoutLoaded) {
              if (state.workouts.isEmpty) {
                return SizedBox(
                  height: SizeConfig.screenHeight! * 0.20,
                  child: const Center(
                    child: Text('No workouts available at the moment'),
                  ),
                );
              }
              
              return SizedBox(
                height: SizeConfig.screenHeight! * 0.20,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.workouts.length > 5 ? 5 : state.workouts.length,
                  itemBuilder: (context, index) {
                    final workout = state.workouts[index];
                    return Padding(
                      padding: EdgeInsets.only(right: SizeConfig.screenWidth! * 0.04),
                      child: WorkoutCard(workout: workout),
                    );
                  },
                ),
              );
            } else if (state is WorkoutError) {
              return SizedBox(
                height: SizeConfig.screenHeight! * 0.20,
                child: Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: SizeConfig.screenHeight! * 0.20,
                child: const Center(child: Text('No workouts available')),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildChallenges() {
    final screenHeight = SizeConfig.screenHeight ?? MediaQuery.of(context).size.height;
    final screenWidth = SizeConfig.screenWidth ?? MediaQuery.of(context).size.width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Challenges',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/challenges');
              },
              child: Text(
                'More',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        SizedBox(
          height: screenHeight * 0.15,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              ChallengeCard(
                title: '7 Days Abs Challenge',
                participants: 2453,
                imageUrl: 'assets/images/workout_1.jpg',
              ),
              ChallengeCard(
                title: '30 Days Push-up Challenge',
                participants: 1823,
                imageUrl: 'assets/images/workout_2.jpg',
              ),
              ChallengeCard(
                title: 'Full Body Power',
                participants: 953,
                imageUrl: 'assets/images/workout_3.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArticles() {
    final screenHeight = SizeConfig.screenHeight ?? MediaQuery.of(context).size.height;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fitness Articles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/articles');
              },
              child: Text(
                'See All',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        const ArticleCard(
          title: 'How to Stay Motivated for Your Workout Routine',
          author: 'John Fitness',
          readTime: '5 min read',
          imageUrl: 'assets/images/workout_1.jpg',
        ),
        SizedBox(height: screenHeight * 0.02),
        const ArticleCard(
          title: 'The Best Foods to Eat Before and After a Workout',
          author: 'Sarah Nutrition',
          readTime: '4 min read',
          imageUrl: 'assets/images/nutrition_1.jpg',
        ),
      ],
    );
  }
}

  Widget _buildWorkoutsTab() {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      builder: (context, state) {
        if (state is WorkoutLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WorkoutLoaded) {
          if (state.workouts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No workouts available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WorkoutBloc>().add(FetchWorkoutsEvent());
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
            itemCount: state.workouts.length,
            itemBuilder: (context, index) {
              final workout = state.workouts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: WorkoutCard(workout: workout),
              );
            },
          );
        } else if (state is WorkoutError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<WorkoutBloc>().add(FetchWorkoutsEvent());
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }
        
        return const Center(child: Text('No workouts data'));
      },
    );
  }

  Widget _buildNutritionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Nutrition',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          
          // Daily Calorie Summary Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Today\'s Calories',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutritionStat(
                      title: 'Goal',
                      value: '2,200',
                      unit: 'kcal',
                      color: Colors.blue,
                    ),
                    _buildNutritionStat(
                      title: 'Consumed',
                      value: '1,450',
                      unit: 'kcal',
                      color: Colors.green,
                    ),
                    _buildNutritionStat(
                      title: 'Remaining',
                      value: '750',
                      unit: 'kcal',
                      color: Colors.orange,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0.65,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 10,
                ),
              ],
            ),
          ),
          
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          
          // Macros Summary
          Text(
            'Macronutrients',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroCard(
                title: 'Protein',
                value: '95g',
                target: '120g',
                color: Colors.red.shade400,
                percent: 0.79,
              ),
              _buildMacroCard(
                title: 'Carbs',
                value: '180g',
                target: '220g',
                color: Colors.blue.shade400,
                percent: 0.81,
              ),
              _buildMacroCard(
                title: 'Fat',
                value: '45g',
                target: '70g',
                color: Colors.yellow.shade700,
                percent: 0.64,
              ),
            ],
          ),
          
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          
          // Meal Tracking
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Meals',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/meal-planning');
                },
                icon: Icon(Icons.add, size: 18),
                label: Text('Add Meal'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildMealCard(
            title: 'Breakfast',
            time: '07:30 AM',
            calories: '450',
            foods: ['Oatmeal with berries', 'Greek yogurt', 'Coffee'],
          ),
          SizedBox(height: 12),
          _buildMealCard(
            title: 'Lunch',
            time: '12:15 PM',
            calories: '650',
            foods: ['Grilled chicken salad', 'Whole grain bread', 'Apple'],
          ),
          SizedBox(height: 12),
          _buildMealCard(
            title: 'Snack',
            time: '03:30 PM',
            calories: '180',
            foods: ['Protein shake', 'Almonds'],
          ),
          SizedBox(height: 12),
          _buildMealCard(
            title: 'Dinner',
            time: '07:00 PM',
            calories: '620',
            foods: ['Salmon', 'Quinoa', 'Steamed vegetables'],
            isPlanned: true,
          ),
          
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          
          // Water Tracking
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Water Tracker',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5/8 glasses',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Decrease water count logic
                          },
                          icon: Icon(Icons.remove_circle_outline, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () {
                            // Increase water count logic
                          },
                          icon: Icon(Icons.add_circle_outline, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(8, (index) {
                    return Icon(
                      Icons.water_drop,
                      color: index < 5 ? Colors.blue : Colors.blue.withOpacity(0.3),
                      size: 28,
                    );
                  }),
                ),
              ],
            ),
          ),
          
          SizedBox(height: SizeConfig.screenHeight! * 0.05),
        ],
      ),
    );
  }
  
  Widget _buildNutritionStat({
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        RichText(
          text: TextSpan(
            text: value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            children: [
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildMacroCard({
    required String title,
    required String value,
    required String target,
    required Color color,
    required double percent,
  }) {
    return Container(
      width: SizeConfig.screenWidth! * 0.28,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percent,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 6,
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'of $target',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMealCard({
    required String title,
    required String time,
    required String calories,
    required List<String> foods,
    bool isPlanned = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPlanned 
            ? Colors.grey.withOpacity(0.1) 
            : Theme.of(context).cardColor,
        border: Border.all(
          color: isPlanned 
              ? Colors.grey.shade400 
              : Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  if (isPlanned)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Planned',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 18,
              ),
              SizedBox(width: 4),
              Text(
                '$calories kcal',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: foods.map((food) {
              return Chip(
                label: Text(
                  food,
                  style: TextStyle(fontSize: 12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          final user = state.user;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Hero(
                  tag: 'profileImage',
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                        ? NetworkImage(user.profileImageUrl!) as ImageProvider
                        : const AssetImage('assets/images/profile_placeholder.png'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                _buildProfileMenuItem(
                  icon: Icons.person,
                  title: 'Personal Information',
                  onTap: () {
                    // Navigate to personal info screen
                  },
                ),
                _buildProfileMenuItem(
                  icon: Icons.fitness_center,
                  title: 'My Workouts',
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1; // Navigate to workouts tab
                    });
                  },
                ),
                _buildProfileMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    // Navigate to settings screen
                  },
                ),
                _buildProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    // Show logout confirmation dialog
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
                              // Logout logic here
                              // context.read<AuthBloc>().add(LogoutEvent());
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else if (state is UserError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading profile: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserBloc>().add(GetUserProfileEvent());
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }
        
        return const Center(child: Text('No profile data'));
      },
    );
  }
  
  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
