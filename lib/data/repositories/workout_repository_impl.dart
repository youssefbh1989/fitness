
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  WorkoutRepositoryImpl();
  
  final List<Workout> _mockWorkouts = [
    Workout(
      id: '1',
      title: 'Full Body Workout',
      description: 'A complete full body workout to strengthen and tone your muscles.',
      imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd',
      level: 'Beginner',
      duration: 30,
      category: 'Full Body',
      exercises: [
        Exercise(
          id: '1',
          name: 'Push-ups',
          description: 'A classic exercise for chest, shoulders, and triceps.',
          imageUrl: 'https://example.com/pushups.jpg',
          sets: 3,
          reps: 10,
          equipment: 'None',
        ),
        Exercise(
          id: '2',
          name: 'Squats',
          description: 'A lower body exercise that targets quads, hamstrings, and glutes.',
          imageUrl: 'https://example.com/squats.jpg',
          sets: 3,
          reps: 15,
          equipment: 'None',
        ),
        Exercise(
          id: '3',
          name: 'Planks',
          description: 'A core strengthening exercise.',
          imageUrl: 'https://example.com/planks.jpg',
          sets: 3,
          duration: 30,
          equipment: 'None',
        ),
      ],
    ),
    Workout(
      id: '2',
      title: 'HIIT Cardio',
      description: 'High-intensity interval training to burn calories and improve cardiovascular health.',
      imageUrl: 'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5',
      level: 'Intermediate',
      duration: 20,
      category: 'Cardio',
      exercises: [
        Exercise(
          id: '4',
          name: 'Jumping Jacks',
          description: 'A full-body exercise that increases heart rate.',
          imageUrl: 'https://example.com/jumping_jacks.jpg',
          sets: 4,
          duration: 30,
          equipment: 'None',
        ),
        Exercise(
          id: '5',
          name: 'Mountain Climbers',
          description: 'A dynamic exercise that works multiple muscle groups.',
          imageUrl: 'https://example.com/mountain_climbers.jpg',
          sets: 4,
          duration: 30,
          equipment: 'None',
        ),
        Exercise(
          id: '6',
          name: 'Burpees',
          description: 'A full-body exercise that combines a squat, push-up, and jump.',
          imageUrl: 'https://example.com/burpees.jpg',
          sets: 4,
          reps: 10,
          equipment: 'None',
        ),
      ],
    ),
    Workout(
      id: '3',
      title: 'Core Crusher',
      description: 'Strengthen your core with this targeted ab workout.',
      imageUrl: 'https://images.unsplash.com/photo-1616803689943-5601631c7fec',
      level: 'Beginner',
      duration: 15,
      category: 'Core',
      exercises: [
        Exercise(
          id: '7',
          name: 'Crunches',
          description: 'A basic abdominal exercise.',
          imageUrl: 'https://example.com/crunches.jpg',
          sets: 3,
          reps: 20,
          equipment: 'None',
        ),
        Exercise(
          id: '8',
          name: 'Leg Raises',
          description: 'An exercise that targets the lower abs.',
          imageUrl: 'https://example.com/leg_raises.jpg',
          sets: 3,
          reps: 15,
          equipment: 'None',
        ),
        Exercise(
          id: '9',
          name: 'Russian Twists',
          description: 'An exercise that targets the obliques.',
          imageUrl: 'https://example.com/russian_twists.jpg',
          sets: 3,
          reps: 20,
          equipment: 'None',
        ),
      ],
    ),
    Workout(
      id: '4',
      title: 'Upper Body Strength',
      description: 'Build strength in your arms, shoulders, and chest.',
      imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e',
      level: 'Intermediate',
      duration: 40,
      category: 'Upper Body',
      exercises: [
        Exercise(
          id: '10',
          name: 'Bicep Curls',
          description: 'An exercise that targets the biceps.',
          imageUrl: 'https://example.com/bicep_curls.jpg',
          sets: 3,
          reps: 12,
          equipment: 'Dumbbells',
        ),
        Exercise(
          id: '11',
          name: 'Tricep Dips',
          description: 'An exercise that targets the triceps.',
          imageUrl: 'https://example.com/tricep_dips.jpg',
          sets: 3,
          reps: 15,
          equipment: 'Bench or Chair',
        ),
        Exercise(
          id: '12',
          name: 'Shoulder Press',
          description: 'An exercise that targets the shoulders.',
          imageUrl: 'https://example.com/shoulder_press.jpg',
          sets: 3,
          reps: 12,
          equipment: 'Dumbbells',
        ),
      ],
    ),
    Workout(
      id: '5',
      title: 'Lower Body Blast',
      description: 'Strengthen and tone your legs and glutes.',
      imageUrl: 'https://images.unsplash.com/photo-1434682772747-f16d3ea162c3',
      level: 'Intermediate',
      duration: 35,
      category: 'Lower Body',
      exercises: [
        Exercise(
          id: '13',
          name: 'Squats',
          description: 'A lower body exercise that targets quads, hamstrings, and glutes.',
          imageUrl: 'https://example.com/squats.jpg',
          sets: 4,
          reps: 15,
          equipment: 'None',
        ),
        Exercise(
          id: '14',
          name: 'Lunges',
          description: 'A lower body exercise that targets quads, hamstrings, and glutes.',
          imageUrl: 'https://example.com/lunges.jpg',
          sets: 3,
          reps: 12,
          equipment: 'None',
        ),
        Exercise(
          id: '15',
          name: 'Calf Raises',
          description: 'An exercise that targets the calves.',
          imageUrl: 'https://example.com/calf_raises.jpg',
          sets: 3,
          reps: 20,
          equipment: 'None',
        ),
      ],
    ),
  ];
  
  @override
  Future<Either<Failure, List<Workout>>> getWorkouts() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return Right(_mockWorkouts);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Workout>> getWorkoutById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final workout = _mockWorkouts.firstWhere(
        (w) => w.id == id,
        orElse: () => throw Exception('Workout not found'),
      );
      return Right(workout);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Workout>>> getWorkoutsByCategory(String category) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final workouts = _mockWorkouts.where((w) => w.category == category).toList();
      return Right(workouts);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Workout>>> getFeaturedWorkouts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      // Just return the first 3 workouts as featured
      final workouts = _mockWorkouts.take(3).toList();
      return Right(workouts);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> getWorkoutCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final categories = _mockWorkouts.map((w) => w.category).toSet().toList();
      return Right(categories);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
