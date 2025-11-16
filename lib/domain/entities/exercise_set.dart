
import 'package:equatable/equatable.dart';

class ExerciseSet extends Equatable {
  final String id;
  final double weight;
  final int reps;
  final bool isCompleted;
  final int? restTime; // in seconds
  final String? notes;

  const ExerciseSet({
    required this.id,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
    this.restTime,
    this.notes,
  });

  ExerciseSet copyWith({
    String? id,
    double? weight,
    int? reps,
    bool? isCompleted,
    int? restTime,
    String? notes,
  }) {
    return ExerciseSet(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
      restTime: restTime ?? this.restTime,
      notes: notes ?? this.notes,
    );
  }

  ExerciseSet markAsCompleted() {
    return copyWith(isCompleted: true);
  }

  ExerciseSet markAsIncomplete() {
    return copyWith(isCompleted: false);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'reps': reps,
      'isCompleted': isCompleted,
      'restTime': restTime,
      'notes': notes,
    };
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      id: json['id'] as String,
      weight: (json['weight'] as num).toDouble(),
      reps: json['reps'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      restTime: json['restTime'] as int?,
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, weight, reps, isCompleted, restTime, notes];
}
