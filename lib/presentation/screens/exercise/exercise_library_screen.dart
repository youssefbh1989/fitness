
import 'package:flutter/material.dart';
import '../../../core/utils/size_config.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _categories = [
    'All',
    'Abs',
    'Arms',
    'Back',
    'Chest',
    'Legs',
    'Shoulders',
    'Cardio',
  ];
  
  final List<Exercise> _exercises = [
    Exercise(
      id: '1',
      name: 'Push-up',
      category: 'Chest',
      equipment: 'None',
      difficulty: 'Beginner',
      imageUrl: 'assets/images/exercise_1.jpg',
      instructions: 'Start in a plank position with your hands shoulder-width apart. Lower your body until your chest nearly touches the floor. Pause, then push back up.',
      primaryMuscles: ['Chest', 'Shoulders', 'Triceps'],
      secondaryMuscles: ['Core'],
    ),
    Exercise(
      id: '2',
      name: 'Squat',
      category: 'Legs',
      equipment: 'None',
      difficulty: 'Beginner',
      imageUrl: 'assets/images/exercise_2.jpg',
      instructions: 'Stand with feet shoulder-width apart. Lower your body by bending your knees and pushing your hips back. Keep your chest up. Return to standing position.',
      primaryMuscles: ['Quadriceps', 'Glutes'],
      secondaryMuscles: ['Hamstrings', 'Core'],
    ),
    Exercise(
      id: '3',
      name: 'Pull-up',
      category: 'Back',
      equipment: 'Pull-up Bar',
      difficulty: 'Intermediate',
      imageUrl: 'assets/images/exercise_3.jpg',
      instructions: 'Hang from a pull-up bar with palms facing away. Pull your body up until your chin is above the bar. Lower back down with control.',
      primaryMuscles: ['Latissimus Dorsi', 'Biceps'],
      secondaryMuscles: ['Shoulders', 'Forearms'],
    ),
    Exercise(
      id: '4',
      name: 'Plank',
      category: 'Abs',
      equipment: 'None',
      difficulty: 'Beginner',
      imageUrl: 'assets/images/exercise_4.jpg',
      instructions: 'Get into a push-up position, but rest on your forearms. Keep your body in a straight line from head to heels. Hold this position.',
      primaryMuscles: ['Core'],
      secondaryMuscles: ['Shoulders', 'Back'],
    ),
    Exercise(
      id: '5',
      name: 'Dumbbell Curl',
      category: 'Arms',
      equipment: 'Dumbbells',
      difficulty: 'Beginner',
      imageUrl: 'assets/images/exercise_5.jpg',
      instructions: 'Stand with dumbbells in hand, arms extended. Curl the weights toward your shoulders while keeping your upper arms still. Lower back down.',
      primaryMuscles: ['Biceps'],
      secondaryMuscles: ['Forearms'],
    ),
    Exercise(
      id: '6',
      name: 'Shoulder Press',
      category: 'Shoulders',
      equipment: 'Dumbbells',
      difficulty: 'Intermediate',
      imageUrl: 'assets/images/exercise_6.jpg',
      instructions: 'Sit or stand with dumbbells at shoulder height. Press the weights overhead until arms are extended. Lower back to starting position.',
      primaryMuscles: ['Shoulders'],
      secondaryMuscles: ['Triceps', 'Traps'],
    ),
    Exercise(
      id: '7',
      name: 'Running',
      category: 'Cardio',
      equipment: 'None',
      difficulty: 'Beginner',
      imageUrl: 'assets/images/exercise_7.jpg',
      instructions: 'Start with a light jog and gradually increase your pace. Keep your upper body relaxed and maintain good posture.',
      primaryMuscles: ['Quadriceps', 'Hamstrings', 'Calves'],
      secondaryMuscles: ['Core', 'Glutes'],
    ),
    Exercise(
      id: '8',
      name: 'Deadlift',
      category: 'Back',
      equipment: 'Barbell',
      difficulty: 'Advanced',
      imageUrl: 'assets/images/exercise_8.jpg',
      instructions: 'Stand with feet hip-width apart, barbell over midfoot. Bend at hips and knees to grip the bar. Lift by extending hips and knees. Return bar to floor.',
      primaryMuscles: ['Lower Back', 'Glutes', 'Hamstrings'],
      secondaryMuscles: ['Traps', 'Forearms', 'Quads'],
    ),
  ];

  List<Exercise> get _filteredExercises {
    return _exercises.where((exercise) {
      final matchesCategory = _selectedCategory == 'All' || exercise.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || 
          exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.equipment.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.difficulty.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategorySelector(),
          Expanded(
            child: _filteredExercises.isEmpty
                ? _buildEmptyState()
                : _buildExerciseGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth! * 0.05,
        vertical: SizeConfig.screenHeight! * 0.01,
      ),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search exercises...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.05),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          Text(
            'No exercises found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          Text(
            'Try a different search or category',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = _filteredExercises[index];
        return _buildExerciseCard(exercise);
      },
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return GestureDetector(
      onTap: () {
        _showExerciseDetails(exercise);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                exercise.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildTag(exercise.category, Colors.blue),
                      const SizedBox(width: 6),
                      _buildTag(exercise.difficulty, _getDifficultyColor(exercise.difficulty)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.equipment,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showExerciseDetails(Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      exercise.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              exercise.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to favorites')),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.02),
                      Row(
                        children: [
                          _buildDetailChip(Icons.category, exercise.category),
                          const SizedBox(width: 12),
                          _buildDetailChip(Icons.fitness_center, exercise.equipment),
                          const SizedBox(width: 12),
                          _buildDetailChip(Icons.signal_cellular_alt, exercise.difficulty),
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.03),
                      Text(
                        'Instructions',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.01),
                      Text(
                        exercise.instructions,
                        style: const TextStyle(
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.03),
                      Text(
                        'Target Muscles',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.01),
                      _buildMuscleGroups(exercise),
                      SizedBox(height: SizeConfig.screenHeight! * 0.03),
                      ElevatedButton(
                        onPressed: () {
                          // Add to workout
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${exercise.name} added to workout')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add to Workout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleGroups(Exercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary: ${exercise.primaryMuscles.join(", ")}',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Secondary: ${exercise.secondaryMuscles.join(", ")}',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final String category;
  final String equipment;
  final String difficulty;
  final String imageUrl;
  final String instructions;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.equipment,
    required this.difficulty,
    required this.imageUrl,
    required this.instructions,
    required this.primaryMuscles,
    required this.secondaryMuscles,
  });
}
