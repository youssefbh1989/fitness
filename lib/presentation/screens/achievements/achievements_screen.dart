
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock achievement data
  final List<Map<String, dynamic>> _achievements = [
    {
      'id': 1,
      'title': 'Early Bird',
      'description': 'Complete 5 workouts before 8 AM',
      'icon': Icons.wb_sunny,
      'progress': 3,
      'total': 5,
      'isCompleted': false,
      'category': 'Workout'
    },
    {
      'id': 2,
      'title': 'Iron Pumper',
      'description': 'Complete 10 strength workouts',
      'icon': Icons.fitness_center,
      'progress': 10,
      'total': 10,
      'isCompleted': true,
      'category': 'Workout'
    },
    {
      'id': 3,
      'title': 'Perfect Week',
      'description': 'Complete all planned workouts for a week',
      'icon': Icons.calendar_today,
      'progress': 1,
      'total': 1,
      'isCompleted': true,
      'category': 'Consistency'
    },
    {
      'id': 4,
      'title': 'Nutrition Guru',
      'description': 'Log your meals for 14 consecutive days',
      'icon': Icons.restaurant_menu,
      'progress': 8,
      'total': 14,
      'isCompleted': false,
      'category': 'Nutrition'
    },
    {
      'id': 5,
      'title': 'Water Champion',
      'description': 'Track water intake for 7 consecutive days',
      'icon': Icons.opacity,
      'progress': 7,
      'total': 7,
      'isCompleted': true,
      'category': 'Nutrition'
    },
    {
      'id': 6,
      'title': 'Social Butterfly',
      'description': 'Share 3 completed workouts with friends',
      'icon': Icons.share,
      'progress': 1,
      'total': 3,
      'isCompleted': false,
      'category': 'Social'
    },
    {
      'id': 7,
      'title': 'Progress Tracker',
      'description': 'Log your body measurements 5 times',
      'icon': Icons.speed,
      'progress': 3,
      'total': 5,
      'isCompleted': false,
      'category': 'Progress'
    },
    {
      'id': 8,
      'title': 'Challenge Champion',
      'description': 'Complete a 30-day challenge',
      'icon': Icons.emoji_events,
      'progress': 30,
      'total': 30,
      'isCompleted': true,
      'category': 'Challenge'
    },
  ];
  
  // Mock badges data
  final List<Map<String, dynamic>> _badges = [
    {
      'id': 1,
      'name': 'Bronze Fitness',
      'icon': Icons.military_tech,
      'color': Colors.brown,
      'isUnlocked': true,
      'unlockCriteria': 'Complete 5 workouts',
      'dateUnlocked': '2023-03-15'
    },
    {
      'id': 2,
      'name': 'Silver Fitness',
      'icon': Icons.military_tech,
      'color': Colors.grey[400],
      'isUnlocked': true,
      'unlockCriteria': 'Complete 25 workouts',
      'dateUnlocked': '2023-05-22'
    },
    {
      'id': 3,
      'name': 'Gold Fitness',
      'icon': Icons.military_tech,
      'color': Colors.amber,
      'isUnlocked': false,
      'unlockCriteria': 'Complete 50 workouts',
      'dateUnlocked': null
    },
    {
      'id': 4,
      'name': 'Nutrition Master',
      'icon': Icons.restaurant,
      'color': Colors.green,
      'isUnlocked': true,
      'unlockCriteria': 'Track nutrition for 30 days',
      'dateUnlocked': '2023-04-10'
    },
    {
      'id': 5,
      'name': 'Cardio King',
      'icon': Icons.directions_run,
      'color': Colors.red,
      'isUnlocked': false,
      'unlockCriteria': 'Complete 20 cardio workouts',
      'dateUnlocked': null
    },
    {
      'id': 6,
      'name': '30-Day Streak',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
      'isUnlocked': false,
      'unlockCriteria': 'Use the app for 30 consecutive days',
      'dateUnlocked': null
    },
    {
      'id': 7,
      'name': 'Community Star',
      'icon': Icons.people,
      'color': Colors.blue,
      'isUnlocked': true,
      'unlockCriteria': 'Make 10 posts in the community',
      'dateUnlocked': '2023-06-05'
    },
    {
      'id': 8,
      'name': 'Weight Goal Achieved',
      'icon': Icons.check_circle,
      'color': Colors.purple,
      'isUnlocked': false,
      'unlockCriteria': 'Reach your target weight goal',
      'dateUnlocked': null
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Achievements',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _buildHeader(),
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Achievements'),
              Tab(text: 'Badges'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAchievementsTab(),
                _buildBadgesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Calculate stats
    final completedAchievements = _achievements.where((a) => a['isCompleted']).length;
    final totalAchievements = _achievements.length;
    final unlockedBadges = _badges.where((b) => b['isUnlocked']).length;
    final totalBadges = _badges.length;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(completedAchievements, totalAchievements, 'Achievements'),
              _buildStatItem(unlockedBadges, totalBadges, 'Badges'),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: completedAchievements / totalAchievements,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 8),
          Text(
            'Overall Progress: ${(completedAchievements / totalAchievements * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(int value, int total, String label) {
    return Column(
      children: [
        Text(
          '$value/$total',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsTab() {
    // Get unique categories
    final categories = _achievements.map((a) => a['category'] as String).toSet().toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryAchievements = _achievements.where((a) => a['category'] == category).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...categoryAchievements.map((achievement) => _buildAchievementItem(achievement)),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _buildAchievementItem(Map<String, dynamic> achievement) {
    final double progress = achievement['progress'] / achievement['total'];
    final bool isCompleted = achievement['isCompleted'];
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? Theme.of(context).colorScheme.primary 
                    : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement['icon'],
                color: isCompleted ? Colors.white : Colors.grey,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement['description'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCompleted 
                                  ? Theme.of(context).colorScheme.primary 
                                  : AppTheme.secondaryColor,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${achievement['progress']}/${achievement['total']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCompleted 
                              ? Theme.of(context).colorScheme.primary 
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _badges.length,
      itemBuilder: (context, index) {
        return _buildBadgeItem(_badges[index]);
      },
    );
  }

  Widget _buildBadgeItem(Map<String, dynamic> badge) {
    final bool isUnlocked = badge['isUnlocked'];
    
    return GestureDetector(
      onTap: () => _showBadgeDetails(badge),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isUnlocked ? badge['color'] : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      badge['icon'],
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  if (!isUnlocked)
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                badge['name'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? Colors.black87 : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isUnlocked ? 'Unlocked' : 'Locked',
                style: TextStyle(
                  color: isUnlocked ? Theme.of(context).colorScheme.primary : Colors.grey,
                  fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBadgeDetails(Map<String, dynamic> badge) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: badge['isUnlocked'] ? badge['color'] : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  badge['icon'],
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                badge['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Unlock Criteria:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge['unlockCriteria'],
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (badge['isUnlocked']) ...[
                const Text(
                  'Date Unlocked:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  badge['dateUnlocked'],
                  style: const TextStyle(fontSize: 16),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
