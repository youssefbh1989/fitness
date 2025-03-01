
import 'package:equatable/equatable.dart';

class ExerciseSet extends Equatable {
  final String id;
  final double weight;
  final int reps;
  final bool isCompleted;

  const ExerciseSet({
    required this.id,
    required this.weight,
    required this.reps,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [id, weight, reps, isCompleted];
}
