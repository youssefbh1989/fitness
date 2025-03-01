import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/exercise.dart';
import '../../blocs/exercise/exercise_bloc.dart';
import '../../blocs/exercise/exercise_event.dart';
import '../../blocs/exercise/exercise_state.dart';
import '../../routes/app_router.dart';
import '../../widgets/exercise_card.dart';

class ExerciseListScreen extends StatefulWidget {
  final String? category;
  final String? muscleGroup;

  const ExerciseListScreen({
    Key? key,
    this.category,
    this.muscleGroup,
  }) : super(key: key);

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      context.read<ExerciseBloc>().add(GetExercisesByCategoryEvent(widget.category!));
    } else if (widget.muscleGroup != null) {
      context.read<ExerciseBloc>().add(GetExercisesByMuscleGroupEvent(widget.muscleGroup!));
    } else {
      context.read<ExerciseBloc>().add(GetExercisesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.category ?? widget.muscleGroup ?? 'All Exercises';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExercisesLoaded) {
            return _buildExerciseList(state.exercises);
          } else if (state is ExerciseError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No exercises found'));
          }
        },
      ),
    );
  }

  Widget _buildExerciseList(List<Exercise> exercises) {
    if (exercises.isEmpty) {
      return const Center(child: Text('No exercises found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ExerciseCard(
            exercise: exercise,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.exerciseDetail,
                arguments: exercise.id,
              );
            },
          ),
        );
      },
    );
  }
}