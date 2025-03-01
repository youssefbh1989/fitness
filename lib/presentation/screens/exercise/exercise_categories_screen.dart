
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/exercise/exercise_bloc.dart';
import '../../blocs/exercise/exercise_event.dart';
import '../../blocs/exercise/exercise_state.dart';
import '../../routes/app_router.dart';

class ExerciseCategoriesScreen extends StatefulWidget {
  const ExerciseCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseCategoriesScreen> createState() => _ExerciseCategoriesScreenState();
}

class _ExerciseCategoriesScreenState extends State<ExerciseCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExerciseBloc>().add(GetExerciseCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Categories'),
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExerciseCategoriesLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return _buildCategoryCard(category);
                },
              ),
            );
          } else if (state is ExerciseError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No categories found'));
          }
        },
      ),
    );
  }

  Widget _buildCategoryCard(String category) {
    final categoryImages = {
      'Bodyweight': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
      'Strength': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48',
      'Cardio': 'https://images.unsplash.com/photo-1538805060514-97d9cc17730c',
      'Flexibility': 'https://images.unsplash.com/photo-1518611012118-696072aa579a',
    };

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context, 
          AppRouter.exerciseList,
          arguments: {'category': category},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade500,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(categoryImages[category] ?? 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
