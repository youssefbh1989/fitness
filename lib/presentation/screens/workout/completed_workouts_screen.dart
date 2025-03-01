
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/completed_workout.dart';
import '../../blocs/workout_tracker/workout_tracker_bloc.dart';
import '../../widgets/workout_history_card.dart';

class CompletedWorkoutsScreen extends StatefulWidget {
  const CompletedWorkoutsScreen({Key? key}) : super(key: key);

  @override
  State<CompletedWorkoutsScreen> createState() => _CompletedWorkoutsScreenState();
}

class _CompletedWorkoutsScreenState extends State<CompletedWorkoutsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _periods = ['Weekly', 'Monthly', 'All Time'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _periods.length, vsync: this);
    context.read<WorkoutTrackerBloc>().add(FetchCompletedWorkoutsEvent(period: 'weekly'));
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final period = _periods[_tabController.index].toLowerCase();
        context.read<WorkoutTrackerBloc>().add(FetchCompletedWorkoutsEvent(period: period));
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _periods.map((period) => Tab(text: period)).toList(),
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
        ),
      ),
      body: BlocBuilder<WorkoutTrackerBloc, WorkoutTrackerState>(
        builder: (context, state) {
          if (state is WorkoutTrackerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CompletedWorkoutsLoaded) {
            if (state.workouts.isEmpty) {
              return _buildEmptyState();
            }
            
            return _buildWorkoutHistory(state.workouts);
          } else if (state is WorkoutTrackerError) {
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
                      final period = _periods[_tabController.index].toLowerCase();
                      context.read<WorkoutTrackerBloc>().add(
                        FetchCompletedWorkoutsEvent(period: period),
                      );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/workout/create');
        },
        child: const Icon(Icons.add),
        tooltip: 'Start New Workout',
      ),
    );
  }

  Widget _buildEmptyState() {
    final period = _periods[_tabController.index];
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No workouts completed $period',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your workouts to see your progress here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Start a Workout'),
              onPressed: () {
                Navigator.pushNamed(context, '/workout/create');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutHistory(List<CompletedWorkout> workouts) {
    // Group workouts by month/week depending on selected period
    final groupedWorkouts = <String, List<CompletedWorkout>>{};
    
    for (var workout in workouts) {
      final date = DateTime.fromMillisecondsSinceEpoch(workout.completedAt);
      String groupKey;
      
      if (_tabController.index == 0) { // Weekly
        // Format: "Week of Jan 1, 2023"
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        groupKey = 'Week of ${DateFormat.MMMd().format(startOfWeek)}, ${date.year}';
      } else if (_tabController.index == 1) { // Monthly
        // Format: "January 2023"
        groupKey = DateFormat.yMMMM().format(date);
      } else { // All time
        // Format: "2023"
        groupKey = date.year.toString();
      }
      
      if (groupedWorkouts.containsKey(groupKey)) {
        groupedWorkouts[groupKey]!.add(workout);
      } else {
        groupedWorkouts[groupKey] = [workout];
      }
    }
    
    // Sort the keys in reverse chronological order
    final sortedKeys = groupedWorkouts.keys.toList()
      ..sort((a, b) {
        // Extract dates from keys and compare them
        if (_tabController.index == 0) { // Weekly
          // Extract date from "Week of Jan 1, 2023"
          final aDate = _parseWeekDate(a);
          final bDate = _parseWeekDate(b);
          return bDate.compareTo(aDate);
        } else if (_tabController.index == 1) { // Monthly
          // Parse "January 2023" format
          final aDate = DateFormat.yMMMM().parse(a);
          final bDate = DateFormat.yMMMM().parse(b);
          return bDate.compareTo(aDate);
        } else { // All time
          // Parse "2023" format
          return int.parse(b).compareTo(int.parse(a));
        }
      });
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final groupKey = sortedKeys[index];
        final groupWorkouts = groupedWorkouts[groupKey]!;
        
        // Sort workouts within the group by date (newest first)
        groupWorkouts.sort((a, b) => b.completedAt.compareTo(a.completedAt));
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                groupKey,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...groupWorkouts.map((workout) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: WorkoutHistoryCard(
                  workout: workout,
                  onTap: () => _showWorkoutDetailsDialog(workout),
                ),
              );
            }).toList(),
            const Divider(height: 32),
          ],
        );
      },
    );
  }
  
  DateTime _parseWeekDate(String weekText) {
    // Extract date from "Week of Jan 1, 2023"
    final parts = weekText.replaceAll('Week of ', '').split(', ');
    final monthDay = parts[0]; // "Jan 1"
    final year = int.parse(parts[1]); // "2023"
    
    // Create a DateTime from the monthDay and year
    return DateFormat('MMM d, y').parse('$monthDay, $year');
  }

  void _showWorkoutDetailsDialog(CompletedWorkout workout) {
    final date = DateTime.fromMillisecondsSinceEpoch(workout.completedAt);
    final formattedDate = DateFormat.yMMMd().add_jm().format(date);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.workoutName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow(
                    'Duration',
                    _formatDuration(workout.duration),
                    Icons.timer,
                  ),
                  _buildStatRow(
                    'Calories',
                    '${workout.caloriesBurned} kcal',
                    Icons.local_fire_department,
                  ),
                  _buildStatRow(
                    'Exercises',
                    workout.exercisesCompleted.toString(),
                    Icons.fitness_center,
                  ),
                  _buildStatRow(
                    'Total Sets',
                    workout.totalSets.toString(),
                    Icons.repeat,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Exercises',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: workout.exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = workout.exercises[index];
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(exercise.name),
                          subtitle: Text(
                            '${exercise.sets} sets | ${exercise.reps} reps | ${exercise.weight} kg',
                          ),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        onPressed: () {
                          Navigator.pop(context);
                          // Implement sharing functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sharing workout...')),
                          );
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Repeat Workout'),
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to start this workout again
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Starting workout...')),
                          );
                        },
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

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
