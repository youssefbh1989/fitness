
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/workout.dart';
import '../../widgets/custom_app_bar.dart';

class WorkoutTrackingScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutTrackingScreen({Key? key, required this.workout}) : super(key: key);

  @override
  State<WorkoutTrackingScreen> createState() => _WorkoutTrackingScreenState();
}

class _WorkoutTrackingScreenState extends State<WorkoutTrackingScreen> {
  late List<bool> completedExercises;
  late Stopwatch stopwatch;
  late Duration currentDuration;
  late Timer? timer;
  bool isWorkoutStarted = false;
  bool isWorkoutCompleted = false;

  @override
  void initState() {
    super.initState();
    completedExercises = List.generate(widget.workout.exercises.length, (_) => false);
    stopwatch = Stopwatch();
    currentDuration = const Duration();
    timer = null;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startWorkout() {
    setState(() {
      isWorkoutStarted = true;
      stopwatch.start();
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          currentDuration = stopwatch.elapsed;
        });
      });
    });
  }

  void completeWorkout() {
    setState(() {
      isWorkoutCompleted = true;
      stopwatch.stop();
      timer?.cancel();
    });

    // TODO: Save workout results to repository
    
    // Show completion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Completed!'),
        content: Text('Time: ${_formatDuration(currentDuration)}\n'
            'Exercises Completed: ${completedExercises.where((e) => e).length}/${widget.workout.exercises.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void toggleExerciseCompletion(int index) {
    setState(() {
      completedExercises[index] = !completedExercises[index];
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.workout.name,
        showBackButton: true,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.all(SizeConfig.mediumPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Time',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _formatDuration(currentDuration),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Progress',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${completedExercises.where((e) => e).length}/${widget.workout.exercises.length}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(SizeConfig.defaultPadding),
              itemCount: widget.workout.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.workout.exercises[index];
                return Card(
                  margin: EdgeInsets.only(bottom: SizeConfig.defaultPadding),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: completedExercises[index]
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      child: Icon(
                        completedExercises[index]
                            ? Icons.check
                            : Icons.fitness_center,
                        color: completedExercises[index]
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
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
                    trailing: Checkbox(
                      value: completedExercises[index],
                      onChanged: isWorkoutStarted
                          ? (_) => toggleExerciseCompletion(index)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
        child: ElevatedButton(
          onPressed: isWorkoutCompleted
              ? null
              : (isWorkoutStarted ? completeWorkout : startWorkout),
          style: ElevatedButton.styleFrom(
            backgroundColor: isWorkoutStarted
                ? isWorkoutCompleted
                    ? Colors.grey
                    : Colors.red
                : Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultPadding),
          ),
          child: Text(
            isWorkoutStarted
                ? (isWorkoutCompleted ? 'COMPLETED' : 'COMPLETE WORKOUT')
                : 'START WORKOUT',
          ),
        ),
      ),
    );
  }
}
