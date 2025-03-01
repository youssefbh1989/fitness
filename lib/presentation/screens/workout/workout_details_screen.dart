
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/entities/exercise.dart';
import '../../blocs/workout/workout_bloc.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailsScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWorkoutInfo(),
                _buildWorkoutDescription(),
                _buildDivider('Exercises'),
                _buildExercisesList(),
                _buildDivider('Equipment Needed'),
                _buildEquipmentList(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.workout.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.workout.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/workout_placeholder.jpg',
                  fit: BoxFit.cover,
                );
              },
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
      actions: [
        IconButton(
          icon: Icon(
            widget.workout.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () {
            // Toggle favorite status
            context.read<WorkoutBloc>().add(
              ToggleWorkoutFavoriteEvent(workout: widget.workout),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            // Share functionality
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutInfo() {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(
            Icons.fitness_center,
            '${widget.workout.exercises.length} exercises',
          ),
          _buildInfoItem(
            Icons.timer,
            '${widget.workout.duration} min',
          ),
          _buildInfoItem(
            Icons.local_fire_department,
            '${widget.workout.calories} cal',
          ),
          _buildInfoItem(
            Icons.speed,
            widget.workout.difficulty,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildWorkoutDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this workout',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.workout.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(String title) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildExercisesList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.05),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.workout.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.workout.exercises[index];
          return _buildExerciseItem(exercise, index);
        },
      ),
    );
  }

  Widget _buildExerciseItem(Exercise exercise, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(exercise.imageUrl),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) => const AssetImage('assets/images/exercise_placeholder.jpg'),
          ),
        ),
      ),
      title: Text(
        exercise.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${exercise.sets} sets • ${exercise.reps} reps • ${exercise.duration}s rest',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () => _showExerciseDetails(exercise),
      ),
    );
  }

  Widget _buildEquipmentList() {
    final List<String> equipment = widget.workout.equipment ?? ['No equipment needed'];
    
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: equipment.map((item) => Chip(
          label: Text(item),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),
        )).toList(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Schedule'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => _startWorkout(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('START WORKOUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExerciseDetails(Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: SizeConfig.screenHeight! * 0.8,
          padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Text(
                exercise.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  exercise.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, size: 80, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'How to perform',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    exercise.instructions ?? 'No instructions available for this exercise.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Sets',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${exercise.sets}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Reps',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${exercise.reps}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Rest',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${exercise.duration}s',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _startWorkout() {
    Navigator.of(context).pushNamed(
      '/workout_session',
      arguments: widget.workout,
    );
  }
}
