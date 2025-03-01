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
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserProfileEvent());
    context.read<WorkoutBloc>().add(FetchWorkoutsEvent());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth! * 0.05,
            vertical: SizeConfig.screenHeight! * 0.02,
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
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String userName = "Fitness Enthusiast";
        if (state is UserLoaded) {
          userName = state.user.name.split(' ')[0];
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
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
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
              onPressed: () {},
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
              return const Center(child: CircularProgressIndicator());
            } else if (state is WorkoutLoaded) {
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
            } else {
              return const Center(child: Text('No workouts available'));
            }
          },
        ),
      ],
    );
  }

  Widget _buildChallenges() {
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
              onPressed: () {},
              child: Text(
                'More',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        SizedBox(
          height: SizeConfig.screenHeight! * 0.15,
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
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        const ArticleCard(
          title: 'How to Stay Motivated for Your Workout Routine',
          author: 'John Fitness',
          readTime: '5 min read',
          imageUrl: 'assets/images/workout_1.jpg',
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
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