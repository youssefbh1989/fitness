
import 'package:equatable/equatable.dart';

class Progress extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final double weight;
  final double? bodyFat;
  final double? muscleMass;
  final int? activeMinutes;
  final int? burnedCalories;
  final int? completedWorkouts;

  const Progress({
    required this.id,
    required this.userId,
    required this.date,
    required this.weight,
    this.bodyFat,
    this.muscleMass,
    this.activeMinutes,
    this.burnedCalories,
    this.completedWorkouts,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        weight,
        bodyFat,
        muscleMass,
        activeMinutes,
        burnedCalories,
        completedWorkouts,
      ];

  Progress copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? weight,
    double? bodyFat,
    double? muscleMass,
    int? activeMinutes,
    int? burnedCalories,
    int? completedWorkouts,
  }) {
    return Progress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      bodyFat: bodyFat ?? this.bodyFat,
      muscleMass: muscleMass ?? this.muscleMass,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      burnedCalories: burnedCalories ?? this.burnedCalories,
      completedWorkouts: completedWorkouts ?? this.completedWorkouts,
    );
  }
}
