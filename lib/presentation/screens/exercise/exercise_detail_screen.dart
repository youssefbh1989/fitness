
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../routes/app_router.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final int exerciseId;
  
  const ExerciseDetailScreen({
    Key? key, 
    required this.exerciseId,
  }) : super(key: key);

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  
  // This would come from a repository in a real implementation
  final Map<String, dynamic> _exercise = {
    'id': 1,
    'name': 'Dumbbell Bench Press',
    'category': 'Chest',
    'difficulty': 'Intermediate',
    'equipment': 'Dumbbells, Bench',
    'muscleGroup': 'Chest, Triceps, Shoulders',
    'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'video': 'https://example.com/dumbbell_bench_press.mp4',
    'description': 'The dumbbell bench press is a compound exercise that targets the chest, shoulders, and triceps. It is an effective exercise for building upper body strength and muscle mass.',
    'instructions': [
      'Lie on a flat bench with a dumbbell in each hand, held at the sides of your chest.',
      'Push the dumbbells up until your arms are fully extended, with the weights directly above your shoulders.',
      'Lower the dumbbells back to the starting position, keeping control throughout the movement.',
      'Repeat for the desired number of repetitions.'
    ],
    'tips': [
      'Keep your feet flat on the floor for stability.',
      'Maintain a neutral spine throughout the movement.',
      'Don\'t lock your elbows at the top of the movement.',
      'Control the descent to maximize muscle engagement.'
    ],
    'variations': [
      'Incline Dumbbell Press - Targets upper chest more',
      'Decline Dumbbell Press - Targets lower chest more',
      'Single Arm Dumbbell Press - Increases stabilizer engagement',
      'Close Grip Dumbbell Press - Targets triceps more'
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Share functionality
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_exercise['name'], 
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: _exercise['image'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(),
                  const SizedBox(height: 20),
                  _buildDescription(),
                  const SizedBox(height: 20),
                  _buildPlayVideoButton(),
                  const SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: const [
                      Tab(text: 'Instructions'),
                      Tab(text: 'Tips'),
                      Tab(text: 'Variations'),
                      Tab(text: 'Related'),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildInstructionsList(),
                        _buildTipsList(),
                        _buildVariationsList(),
                        _buildRelatedExercises(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context, 
                      AppRouter.workoutTracking,
                      arguments: {'exerciseId': widget.exerciseId},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('START EXERCISE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem(Icons.fitness_center, 'Category', _exercise['category']),
        _buildInfoItem(Icons.speed, 'Difficulty', _exercise['difficulty']),
        _buildInfoItem(Icons.category, 'Equipment', _exercise['equipment'].split(',')[0]),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _exercise['description'],
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Target Muscles',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _exercise['muscleGroup'],
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayVideoButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context, 
          AppRouter.videoPlayer,
          arguments: {'videoUrl': _exercise['video'], 'title': _exercise['name']},
        );
      },
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: CachedNetworkImageProvider(_exercise['image']),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _exercise['instructions'].length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(_exercise['instructions'][index]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipsList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _exercise['tips'].length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(_exercise['tips'][index]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVariationsList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _exercise['variations'].length,
      itemBuilder: (context, index) {
        final variation = _exercise['variations'][index];
        final parts = variation.split(' - ');
        final name = parts[0];
        final description = parts.length > 1 ? parts[1] : '';
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.swap_horiz,
                color: AppTheme.secondaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRelatedExercises() {
    // Mock related exercises
    final List<Map<String, String>> relatedExercises = [
      {
        'name': 'Barbell Bench Press',
        'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
      },
      {
        'name': 'Push-ups',
        'image': 'https://images.unsplash.com/photo-1598971639058-fab7941123d6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80',
      },
      {
        'name': 'Chest Fly',
        'image': 'https://images.unsplash.com/photo-1598971639058-fab7941123d6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80',
      },
    ];
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: relatedExercises.length,
      itemBuilder: (context, index) {
        final exercise = relatedExercises[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the related exercise
          },
          child: Container(
            width: 150,
            margin: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: exercise['image']!,
                    height: 100,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  exercise['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
