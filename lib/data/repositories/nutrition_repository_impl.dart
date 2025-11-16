
import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/nutrition.dart';
import '../../domain/repositories/nutrition_repository.dart';

class NutritionRepositoryImpl implements NutritionRepository {
  // Mock data for demonstration
  final List<NutritionPlan> _mockNutritionPlans = [
    NutritionPlan(
      id: '1',
      title: 'Weight Loss Plan',
      description: 'A balanced plan for healthy weight loss',
      imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061',
      goal: 'Weight Loss',
      meals: [],
      isPremium: false,
    ),
    NutritionPlan(
      id: '2',
      title: 'Muscle Building Plan',
      description: 'High protein plan for muscle gain',
      imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554',
      goal: 'Muscle Gain',
      meals: [],
      isPremium: false,
    ),
    NutritionPlan(
      id: '3',
      title: 'Maintenance Plan',
      description: 'Balanced nutrition for weight maintenance',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
      goal: 'Maintenance',
      meals: [],
      isPremium: false,
    ),
  ];

  final List<String> _goals = [
    'Weight Loss',
    'Muscle Gain',
    'Maintenance',
    'Athletic Performance',
    'General Health',
  ];

  @override
  Future<Either<Failure, List<NutritionPlan>>> getNutritionPlans() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(_mockNutritionPlans);
    } on ServerException {
      return Left(ServerFailure('Failed to fetch nutrition plans'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionPlan>> getNutritionPlanById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final plan = _mockNutritionPlans.firstWhere(
        (plan) => plan.id == id,
        orElse: () => throw ServerException('Plan not found'),
      );
      return Right(plan);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NutritionPlan>>> getNutritionPlansByGoal(String goal) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final filteredPlans = _mockNutritionPlans
          .where((plan) => plan.goal.toLowerCase() == goal.toLowerCase())
          .toList();
      return Right(filteredPlans);
    } on ServerException {
      return Left(ServerFailure('Failed to fetch nutrition plans by goal'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getNutritionGoals() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return Right(_goals);
    } on ServerException {
      return Left(ServerFailure('Failed to fetch nutrition goals'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
