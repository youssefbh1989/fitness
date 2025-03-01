
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/workout.dart';
import '../../blocs/workout/workout_bloc.dart';
import '../../blocs/workout/workout_event.dart';
import '../../blocs/workout/workout_state.dart';
import '../../routes/app_router.dart';
import '../../widgets/workout_card.dart';

class WorkoutListScreen extends StatefulWidget {
  final String category;
  
  const WorkoutListScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(GetWorkoutsByCategoryEvent(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Workouts'),
        centerTitle: true,
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WorkoutsLoaded) {
            return _buildWorkoutsList(state.workouts);
          } else if (state is WorkoutError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text('No workouts available'),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutsList(List<Workout> workouts) {
    if (workouts.isEmpty) {
      return const Center(
        child: Text('No workouts found for this category'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return WorkoutCard(
          workout: workout,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouter.workoutDetail,
              arguments: workout.id,
            );
          },
        );
      },
    );
  }
}
