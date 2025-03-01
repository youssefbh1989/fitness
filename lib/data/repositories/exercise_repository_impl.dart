
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  ExerciseRepositoryImpl();
  
  final List<Exercise> _mockExercises = [
    Exercise(
      id: '1',
      name: 'Push-ups',
      description: 'A classic exercise for chest, shoulders, and triceps.',
      imageUrl: 'https://images.unsplash.com/photo-1616803689943-5601631c7fec',
      sets: 3,
      reps: 12,
      equipment: 'None',
      category: 'Bodyweight',
      muscleGroup: 'Chest',
      instructions: [
        'Start in a plank position with your hands slightly wider than shoulder-width apart',
        'Lower your body until your chest nearly touches the floor',
        'Push your body back up to the starting position',
        'Repeat for the desired number of repetitions'
      ],
    ),
    Exercise(
      id: '2',
      name: 'Squats',
      description: 'A lower body exercise that targets quads, hamstrings, and glutes.',
      imageUrl: 'https://images.unsplash.com/photo-1574680178050-55c6a6a96e0a',
      sets: 4,
      reps: 15,
      equipment: 'None',
      category: 'Bodyweight',
      muscleGroup: 'Legs',
      instructions: [
        'Stand with feet shoulder-width apart',
        'Bend your knees and lower your hips as if sitting in a chair',
        'Keep your back straight and knees over your toes',
        'Return to standing position',
        'Repeat for the desired number of repetitions'
      ],
    ),
    Exercise(
      id: '3',
      name: 'Plank',
      description: 'A core strengthening exercise that also engages shoulders and back.',
      imageUrl: 'https://images.unsplash.com/photo-1518310952931-b1de897abd40',
      sets: 3,
      duration: 30,
      equipment: 'None',
      category: 'Bodyweight',
      muscleGroup: 'Core',
      instructions: [
        'Start in a push-up position but with your weight on your forearms',
        'Keep your body in a straight line from head to heels',
        'Engage your core and hold the position',
        'Hold for the desired duration'
      ],
    ),
    Exercise(
      id: '4',
      name: 'Dumbbell Bicep Curls',
      description: 'An isolation exercise for the biceps.',
      imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e',
      sets: 3,
      reps: 12,
      equipment: 'Dumbbells',
      category: 'Strength',
      muscleGroup: 'Arms',
      instructions: [
        'Stand with a dumbbell in each hand, arms at your sides',
        'Keep elbows close to your body and palms facing forward',
        'Curl the weights up to shoulder level while keeping upper arms stationary',
        'Lower the weights back to the starting position',
        'Repeat for the desired number of repetitions'
      ],
    ),
    Exercise(
      id: '5',
      name: 'Lunges',
      description: 'A unilateral exercise for the legs and glutes.',
      imageUrl: 'https://images.unsplash.com/photo-1606328500899-38351f33df21',
      sets: 3,
      reps: 10,
      equipment: 'None',
      category: 'Bodyweight',
      muscleGroup: 'Legs',
      instructions: [
        'Stand with feet hip-width apart',
        'Step forward with one leg and lower your body until both knees are bent at 90 degrees',
        'Push through your front heel to return to the starting position',
        'Repeat with the other leg',
        'Continue alternating legs for the desired number of repetitions'
      ],
    ),
    Exercise(
      id: '6',
      name: 'Pull-ups',
      description: 'An upper body compound exercise for back and biceps.',
      imageUrl: 'https://images.unsplash.com/photo-1598971639058-b12b5b5c74b6',
      sets: 3,
      reps: 8,
      equipment: 'Pull-up Bar',
      category: 'Bodyweight',
      muscleGroup: 'Back',
      instructions: [
        'Hang from a pull-up bar with hands slightly wider than shoulder-width apart',
        'Pull your body up until your chin is above the bar',
        'Lower yourself back down with control',
        'Repeat for the desired number of repetitions'
      ],
    ),
    Exercise(
      id: '7',
      name: 'Bench Press',
      description: 'A compound exercise for chest, shoulders, and triceps.',
      imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48',
      sets: 4,
      reps: 10,
      equipment: 'Barbell, Bench',
      category: 'Strength',
      muscleGroup: 'Chest',
      instructions: [
        'Lie on a bench with feet flat on the floor',
        'Grip the barbell slightly wider than shoulder-width apart',
        'Lower the bar to your chest with control',
        'Press the bar back up to the starting position',
        'Repeat for the desired number of repetitions'
      ],
    ),
    Exercise(
      id: '8',
      name: 'Mountain Climbers',
      description: 'A dynamic exercise that works multiple muscle groups.',
      imageUrl: 'https://images.unsplash.com/photo-1599058917765-a780eda07a3e',
      sets: 3,
      duration: 30,
      equipment: 'None',
      category: 'Cardio',
      muscleGroup: 'Full Body',
      instructions: [
        'Start in a push-up position',
        'Bring one knee toward your chest',
        'Quickly switch legs, extending the bent leg back while bringing the other knee in',
        'Continue alternating legs at a rapid pace',
        'Continue for the desired duration'
      ],
    ),
    Exercise(
      id: '9',
      name: 'Deadlift',
      description: 'A compound exercise that works the lower back, glutes, and hamstrings.',
      imageUrl: 'https://images.unsplash.com/photo-1581009137042-c552e485697a',
      sets: 4,
      reps: 8,
      equipment: 'Barbell',
      category: 'Strength',
      muscleGroup: 'Back',
      instructions: [
        'Stand with feet hip-width apart, barbell over the middle of your feet',
        'Bend at the hips and knees to grip the bar',
        'Keep your back straight and chest up',
        'Lift the bar by extending your hips and knees',
        'Return the bar to the floor with control',
        'Repeat for the desired number of repetitions'
      ],
    ),
    Exercise(
      id: '10',
      name: 'Jumping Jacks',
      description: 'A full-body cardio exercise that increases heart rate.',
      imageUrl: 'https://images.unsplash.com/photo-1599058917212-d750089bc07e',
      sets: 3,
      duration: 60,
      equipment: 'None',
      category: 'Cardio',
      muscleGroup: 'Full Body',
      instructions: [
        'Stand with feet together and arms at your sides',
        'Jump while spreading your legs and raising your arms overhead',
        'Jump again to return to the starting position',
        'Repeat at a quick pace for the desired duration'
      ],
    ),
  ];
  
  @override
  Future<Either<Failure, List<Exercise>>> getExercises() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return Right(_mockExercises);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Exercise>> getExerciseById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final exercise = _mockExercises.firstWhere(
        (e) => e.id == id,
        orElse: () => throw Exception('Exercise not found'),
      );
      return Right(exercise);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Exercise>>> getExercisesByCategory(String category) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final exercises = _mockExercises.where((e) => e.category == category).toList();
      return Right(exercises);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Exercise>>> getExercisesByMuscleGroup(String muscleGroup) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final exercises = _mockExercises.where((e) => e.muscleGroup == muscleGroup).toList();
      return Right(exercises);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> getExerciseCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final categories = _mockExercises.map((e) => e.category ?? '').where((c) => c.isNotEmpty).toSet().toList();
      return Right(categories);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> getMuscleGroups() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final muscleGroups = _mockExercises.map((e) => e.muscleGroup ?? '').where((m) => m.isNotEmpty).toSet().toList();
      return Right(muscleGroups);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
