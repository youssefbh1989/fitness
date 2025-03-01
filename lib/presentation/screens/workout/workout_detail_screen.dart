import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/workout.dart';
import '../../blocs/workout/workout_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../router/app_router.dart';


class WorkoutDetailScreen extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailScreen({
    Key? key,
    required this.workoutId,
  }) : super(key: key);

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(GetWorkoutById(widget.workoutId));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutDetailLoaded) {
            final workout = state.workout;
            return _buildWorkoutDetail(context, workout);
          } else if (state is WorkoutDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
      bottomNavigationBar: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutDetailLoaded) {
            return Container(
              padding: EdgeInsets.all(SizeConfig.defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.workoutTrackingScreen,
                            arguments: state.workout,
                          );
                        },
                        child: const Text('START WORKOUT'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.workoutTimerScreen,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.secondary,
                      ),
                      child: const Icon(Icons.timer),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildWorkoutDetail(BuildContext context, Workout workout) {
    return Stack(
      children: [
        // Cover image
        Container(
          height: SizeConfig.screenHeight * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(workout.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Content
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.35),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workout info
                    Text(
                      workout.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildInfoChip(context, '${workout.duration} min', Icons.timer),
                        const SizedBox(width: 15),
                        _buildInfoChip(context, workout.level, Icons.fitness_center),
                        const SizedBox(width: 15),
                        _buildInfoChip(context, '${workout.caloriesBurn} cal', Icons.local_fire_department),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      workout.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Exercises',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 15),

                    // Exercises list
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: workout.exercises.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final exercise = workout.exercises[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(exercise.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            exercise.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            '${exercise.sets} sets × ${exercise.reps} reps',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Start workout action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Workout started')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('START WORKOUT', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Custom app bar
        const CustomAppBar(
          title: '',
          showBackButton: true,
          transparent: true,
        ),
      ],
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/workout.dart';
import '../../blocs/workout/workout_bloc.dart';
import '../../blocs/workout/workout_event.dart';
import '../../blocs/workout/workout_state.dart';
import '../../routes/app_router.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String workoutId;
  
  const WorkoutDetailScreen({
    Key? key,
    required this.workoutId,
  }) : super(key: key);

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(GetWorkoutByIdEvent(widget.workoutId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WorkoutLoaded) {
            return _buildWorkoutDetail(state.workout);
          } else if (state is WorkoutError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text('Workout not found'),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutDetail(Workout workout) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(workout),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWorkoutInfo(workout),
                const SizedBox(height: 24),
                Text(
                  'Exercises',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildExercisesList(workout.exercises),
                const SizedBox(height: 80), // Space for bottom button
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(Workout workout) {
    return SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          workout.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: workout.imageUrl,
              fit: BoxFit.cover,
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
    );
  }

  Widget _buildWorkoutInfo(Workout workout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          workout.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildInfoItem(Icons.timelapse, '${workout.duration} min'),
            const SizedBox(width: 24),
            _buildInfoItem(Icons.fitness_center, workout.level),
            const SizedBox(width: 24),
            _buildInfoItem(Icons.category, workout.category),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRouter.workoutVideoPlayer,
              arguments: workout,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Start Workout'),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildExercisesList(List<Exercise> exercises) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: exercise.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            title: Text(
              exercise.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(exercise.description),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (exercise.sets != null)
                      _buildExerciseDetail('Sets', exercise.sets.toString()),
                    if (exercise.sets != null && (exercise.reps != null || exercise.duration != null))
                      const SizedBox(width: 16),
                    if (exercise.reps != null)
                      _buildExerciseDetail('Reps', exercise.reps.toString()),
                    if (exercise.duration != null)
                      _buildExerciseDetail('Duration', '${exercise.duration} sec'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseDetail(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
