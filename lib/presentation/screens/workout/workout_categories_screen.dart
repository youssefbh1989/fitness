
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/workout/workout_bloc.dart';
import '../../blocs/workout/workout_event.dart';
import '../../blocs/workout/workout_state.dart';
import '../../routes/app_router.dart';

class WorkoutCategoriesScreen extends StatefulWidget {
  const WorkoutCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutCategoriesScreen> createState() => _WorkoutCategoriesScreenState();
}

class _WorkoutCategoriesScreenState extends State<WorkoutCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(GetWorkoutCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Categories'),
        centerTitle: true,
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WorkoutCategoriesLoaded) {
            return _buildCategoriesList(state.categories);
          } else if (state is WorkoutError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text('No categories available'),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesList(List<String> categories) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.workoutList,
                arguments: categories[index],
              );
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  categories[index],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
