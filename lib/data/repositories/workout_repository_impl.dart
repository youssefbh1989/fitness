
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
import 'package:dartz/dartz.dart';
import 'package:fitbody/core/error/failures.dart';
import 'package:fitbody/domain/entities/workout.dart';
import 'package:fitbody/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final List<Workout> _mockWorkouts = [
    Workout(
      id: '1',
      title: 'Full Body Burn',
      description: 'A complete workout that targets all major muscle groups for a full body burn.',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      duration: 45,
      difficulty: 'Intermediate',
      exercises: [
        Exercise(
          id: '1',
          name: 'Push-ups',
          description: 'Start in a plank position with hands slightly wider than shoulder-width apart. Lower your body until your chest nearly touches the floor, then push back up.',
          imageUrl: 'https://images.unsplash.com/photo-1598971639058-bb01d3c8cc23?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          sets: 3,
          reps: 15,
          restTime: 60,
        ),
        Exercise(
          id: '2',
          name: 'Squats',
          description: 'Stand with feet shoulder-width apart. Lower your body by bending your knees and pushing your hips back as if sitting in a chair. Go as low as you can, then return to standing.',
          imageUrl: 'https://images.unsplash.com/photo-1574231164645-d6f0e8553590?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          sets: 3,
          reps: 20,
          restTime: 60,
        ),
        Exercise(
          id: '3',
          name: 'Plank',
          description: 'Get into a push-up position but rest on your forearms. Keep your body in a straight line from head to heels.',
          imageUrl: 'https://images.unsplash.com/photo-1566241440091-ec10de8db2e1?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          sets: 3,
          reps: 1,
          restTime: 60,
        ),
      ],
    ),
    Workout(
      id: '2',
      title: 'HIIT Cardio',
      description: 'High-intensity interval training to burn calories and improve cardiovascular fitness.',
      imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
      duration: 30,
      difficulty: 'Advanced',
      exercises: [
        Exercise(
          id: '4',
          name: 'Jumping Jacks',
          description: 'Start standing with arms at sides, then jump to a position with legs spread and arms raised overhead, then back to start.',
          imageUrl: 'https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          sets: 3,
          reps: 30,
          restTime: 30,
        ),
        Exercise(
          id: '5',
          name: 'Mountain Climbers',
          description: 'Start in a plank position. Alternately drive knees toward chest in a running motion.',
          imageUrl: 'https://images.unsplash.com/photo-1594381898411-846e7d193883?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          sets: 3,
          reps: 20,
          restTime: 30,
        ),
        Exercise(
          id: '6',
          name: 'Burpees',
          description: 'From standing, drop into a squat position, kick feet back to a plank, do a push-up, jump feet back to squat, then explode upward with a jump.',
          imageUrl: 'https://images.unsplash.com/photo-1593079831268-3381b0db4a77?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          sets: 3,
          reps: 10,
          restTime: 30,
        ),
      ],
    ),
  ];

  final Set<String> _favoriteWorkoutIds = {};

  @override
  Future<Either<Failure, List<Workout>>> getWorkouts() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return mock workouts with updated favorite status
      final workouts = _mockWorkouts.map((workout) {
        return Workout(
          id: workout.id,
          title: workout.title,
          description: workout.description,
          imageUrl: workout.imageUrl,
          duration: workout.duration,
          difficulty: workout.difficulty,
          exercises: workout.exercises,
          isFavorite: _favoriteWorkoutIds.contains(workout.id),
        );
      }).toList();
      
      return Right(workouts);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Workout>> getWorkoutById(String id) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      final workout = _mockWorkouts.firstWhere(
        (w) => w.id == id,
        orElse: () => throw Exception('Workout not found'),
      );
      
      // Return with updated favorite status
      return Right(
        Workout(
          id: workout.id,
          title: workout.title,
          description: workout.description,
          imageUrl: workout.imageUrl,
          duration: workout.duration,
          difficulty: workout.difficulty,
          exercises: workout.exercises,
          isFavorite: _favoriteWorkoutIds.contains(workout.id),
        ),
      );
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Workout>>> getFavoriteWorkouts() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Filter and return favorite workouts
      final favoriteWorkouts = _mockWorkouts
          .where((workout) => _favoriteWorkoutIds.contains(workout.id))
          .map((workout) {
        return Workout(
          id: workout.id,
          title: workout.title,
          description: workout.description,
          imageUrl: workout.imageUrl,
          duration: workout.duration,
          difficulty: workout.difficulty,
          exercises: workout.exercises,
          isFavorite: true,
        );
      }).toList();
      
      return Right(favoriteWorkouts);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteWorkout(String id) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 500));
      
      if (_favoriteWorkoutIds.contains(id)) {
        _favoriteWorkoutIds.remove(id);
      } else {
        _favoriteWorkoutIds.add(id);
      }
      
      return Right(_favoriteWorkoutIds.contains(id));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
