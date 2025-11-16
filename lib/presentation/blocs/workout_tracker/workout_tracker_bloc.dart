import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/entities/exercise.dart';
import '../../../domain/entities/exercise_set.dart';
import '../../../domain/usecases/workout/track_workout_usecase.dart';
import '../../../domain/usecases/workout/complete_workout_usecase.dart';

// Events
abstract class WorkoutTrackerEvent extends Equatable {
  const WorkoutTrackerEvent();

  @override
  List<Object?> get props => [];
}

class StartWorkoutEvent extends WorkoutTrackerEvent {
  final Workout workout;

  const StartWorkoutEvent({required this.workout});

  @override
  List<Object> get props => [workout];
}

class UpdateExerciseSetEvent extends WorkoutTrackerEvent {
  final String exerciseId;
  final String setId;
  final double weight;
  final int reps;

  const UpdateExerciseSetEvent({
    required this.exerciseId,
    required this.setId,
    required this.weight,
    required this.reps,
  });

  @override
  List<Object> get props => [exerciseId, setId, weight, reps];
}

class CompleteExerciseSetEvent extends WorkoutTrackerEvent {
  final String exerciseId;
  final String setId;
  final bool completed;

  const CompleteExerciseSetEvent({
    required this.exerciseId,
    required this.setId,
    required this.completed,
  });

  @override
  List<Object> get props => [exerciseId, setId, completed];
}

class AddExerciseSetEvent extends WorkoutTrackerEvent {
  final String exerciseId;

  const AddExerciseSetEvent({required this.exerciseId});

  @override
  List<Object> get props => [exerciseId];
}

class CompleteWorkoutEvent extends WorkoutTrackerEvent {
  final Workout workout;
  final Duration duration;

  const CompleteWorkoutEvent({
    required this.workout,
    required this.duration,
  });

  @override
  List<Object> get props => [workout, duration];
}

// States
abstract class WorkoutTrackerState extends Equatable {
  const WorkoutTrackerState();

  @override
  List<Object?> get props => [];
}

class WorkoutTrackerInitial extends WorkoutTrackerState {}

class WorkoutTrackerLoading extends WorkoutTrackerState {}

class WorkoutTrackingInProgress extends WorkoutTrackerState {
  final Map<String, List<ExerciseSet>> exerciseSets;

  const WorkoutTrackingInProgress({required this.exerciseSets});

  List<ExerciseSet> getExerciseSets(String exerciseId) {
    return exerciseSets[exerciseId] ?? [];
  }

  @override
  List<Object> get props => [exerciseSets];
}

class WorkoutTrackingCompleted extends WorkoutTrackerState {
  final Workout workout;
  final Duration duration;
  final Map<String, List<ExerciseSet>> completedSets;
  final int totalSetsCompleted;
  final int totalSets;
  final double totalWeightLifted;

  const WorkoutTrackingCompleted({
    required this.workout,
    required this.duration,
    required this.completedSets,
    required this.totalSetsCompleted,
    required this.totalSets,
    required this.totalWeightLifted,
  });

  @override
  List<Object> get props => [
    workout, 
    duration, 
    completedSets, 
    totalSetsCompleted, 
    totalSets, 
    totalWeightLifted
  ];
}

class WorkoutTrackingError extends WorkoutTrackerState {
  final String message;

  const WorkoutTrackingError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class WorkoutTrackerBloc extends Bloc<WorkoutTrackerEvent, WorkoutTrackerState> {
  final TrackWorkoutUseCase trackWorkoutUseCase;
  final CompleteWorkoutUseCase completeWorkoutUseCase;

  WorkoutTrackerBloc({
    required this.trackWorkoutUseCase,
    required this.completeWorkoutUseCase,
  }) : super(WorkoutTrackerInitial()) {
    on<StartWorkoutEvent>(_onStartWorkout);
    on<UpdateExerciseSetEvent>(_onUpdateExerciseSet);
    on<CompleteExerciseSetEvent>(_onCompleteExerciseSet);
    on<AddExerciseSetEvent>(_onAddExerciseSet);
    on<CompleteWorkoutEvent>(_onCompleteWorkout);
  }

  void _onStartWorkout(StartWorkoutEvent event, Emitter<WorkoutTrackerState> emit) {
    try {
      final workout = event.workout;
      final Map<String, List<ExerciseSet>> exerciseSets = {};

      // Initialize exercise sets
      for (final exercise in workout.exercises) {
        final sets = List.generate(
          exercise.defaultSets,
          (index) => ExerciseSet(
            id: 'set_${exercise.id}_$index',
            weight: exercise.defaultWeight,
            reps: exercise.defaultReps,
            isCompleted: false,
          ),
        );

        exerciseSets[exercise.id] = sets;
      }

      emit(WorkoutTrackingInProgress(exerciseSets: exerciseSets));
    } catch (e) {
      emit(WorkoutTrackingError(message: e.toString()));
    }
  }

  void _onUpdateExerciseSet(UpdateExerciseSetEvent event, Emitter<WorkoutTrackerState> emit) {
    try {
      if (state is WorkoutTrackingInProgress) {
        final currentState = state as WorkoutTrackingInProgress;
        final newExerciseSets = Map<String, List<ExerciseSet>>.from(currentState.exerciseSets);

        final exerciseSets = List<ExerciseSet>.from(newExerciseSets[event.exerciseId] ?? []);
        final setIndex = exerciseSets.indexWhere((set) => set.id == event.setId);

        if (setIndex != -1) {
          exerciseSets[setIndex] = ExerciseSet(
            id: event.setId,
            weight: event.weight,
            reps: event.reps,
            isCompleted: exerciseSets[setIndex].isCompleted,
          );

          newExerciseSets[event.exerciseId] = exerciseSets;
          emit(WorkoutTrackingInProgress(exerciseSets: newExerciseSets));
        }
      }
    } catch (e) {
      emit(WorkoutTrackingError(message: e.toString()));
    }
  }

  void _onCompleteExerciseSet(CompleteExerciseSetEvent event, Emitter<WorkoutTrackerState> emit) {
    try {
      if (state is WorkoutTrackingInProgress) {
        final currentState = state as WorkoutTrackingInProgress;
        final newExerciseSets = Map<String, List<ExerciseSet>>.from(currentState.exerciseSets);

        final exerciseSets = List<ExerciseSet>.from(newExerciseSets[event.exerciseId] ?? []);
        final setIndex = exerciseSets.indexWhere((set) => set.id == event.setId);

        if (setIndex != -1) {
          exerciseSets[setIndex] = ExerciseSet(
            id: event.setId,
            weight: exerciseSets[setIndex].weight,
            reps: exerciseSets[setIndex].reps,
            isCompleted: event.completed,
          );

          newExerciseSets[event.exerciseId] = exerciseSets;
          emit(WorkoutTrackingInProgress(exerciseSets: newExerciseSets));
        }
      }
    } catch (e) {
      emit(WorkoutTrackingError(message: e.toString()));
    }
  }

  void _onAddExerciseSet(AddExerciseSetEvent event, Emitter<WorkoutTrackerState> emit) {
    try {
      if (state is WorkoutTrackingInProgress) {
        final currentState = state as WorkoutTrackingInProgress;
        final newExerciseSets = Map<String, List<ExerciseSet>>.from(currentState.exerciseSets);

        final exerciseSets = List<ExerciseSet>.from(newExerciseSets[event.exerciseId] ?? []);

        // Create a new set with default values or copied from the last set if available
        final newSet = exerciseSets.isNotEmpty
            ? ExerciseSet(
                id: 'set_${event.exerciseId}_${exerciseSets.length}',
                weight: exerciseSets.last.weight,
                reps: exerciseSets.last.reps,
                isCompleted: false,
              )
            : ExerciseSet(
                id: 'set_${event.exerciseId}_0',
                weight: 0,
                reps: 0,
                isCompleted: false,
              );

        exerciseSets.add(newSet);
        newExerciseSets[event.exerciseId] = exerciseSets;

        emit(WorkoutTrackingInProgress(exerciseSets: newExerciseSets));
      }
    } catch (e) {
      emit(WorkoutTrackingError(message: e.toString()));
    }
  }

  Future<void> _onCompleteWorkout(CompleteWorkoutEvent event, Emitter<WorkoutTrackerState> emit) async {
    try {
      if (state is WorkoutTrackingInProgress) {
        final currentState = state as WorkoutTrackingInProgress;

        // Calculate workout statistics
        int totalSets = 0;
        int totalSetsCompleted = 0;
        double totalWeightLifted = 0;

        for (final entry in currentState.exerciseSets.entries) {
          final sets = entry.value;
          totalSets += sets.length;

          for (final set in sets) {
            if (set.isCompleted) {
              totalSetsCompleted++;
              totalWeightLifted += set.weight * set.reps;
            }
          }
        }

        // Save workout data
        final result = await completeWorkoutUseCase.execute(
          workout: event.workout,
          duration: event.duration,
          exerciseSets: currentState.exerciseSets,
        );

        result.fold(
          (failure) => emit(WorkoutTrackingError(message: failure.message)),
          (_) => emit(WorkoutTrackingCompleted(
            workout: event.workout,
            duration: event.duration,
            completedSets: currentState.exerciseSets,
            totalSetsCompleted: totalSetsCompleted,
            totalSets: totalSets,
            totalWeightLifted: totalWeightLifted,
          )),
        );
      }
    } catch (e) {
      emit(WorkoutTrackingError(message: e.toString()));
    }
  }
}

// Added timer functionality and related events/states
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/exercise_set.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/repositories/workout_repository.dart';

part 'workout_tracker_event.dart';
part 'workout_tracker_state.dart';

class WorkoutTrackerBloc extends Bloc<WorkoutTrackerEvent, WorkoutTrackerState> {
  Timer? _workoutTimer;
  int _elapsedSeconds = 0;

  WorkoutTrackerBloc() : super(WorkoutTrackerInitial()) {
    on<StartWorkoutEvent>(_onStartWorkout);
    on<PauseWorkoutEvent>(_onPauseWorkout);
    on<ResumeWorkoutEvent>(_onResumeWorkout);
    on<CompleteExerciseEvent>(_onCompleteExercise);
    on<SkipExerciseEvent>(_onSkipExercise);
    on<StartRestTimerEvent>(_onStartRestTimer);
    on<SkipRestEvent>(_onSkipRest);
    on<CompleteWorkoutEvent>(_onCompleteWorkout);
    on<UpdateTimerEvent>(_onUpdateTimer);
  }

  void _onStartWorkout(StartWorkoutEvent event, Emitter<WorkoutTrackerState> emit) {
    _elapsedSeconds = 0;
    _startTimer();

    emit(WorkoutInProgress(
      workout: event.workout,
      currentExerciseIndex: 0,
      completedExercises: [],
      elapsedSeconds: 0,
      isResting: false,
      isPaused: false,
    ));
  }

  void _onPauseWorkout(PauseWorkoutEvent event, Emitter<WorkoutTrackerState> emit) {
    _workoutTimer?.cancel();

    if (state is WorkoutInProgress) {
      final currentState = state as WorkoutInProgress;
      emit(currentState.copyWith(isPaused: true));
    }
  }

  void _onResumeWorkout(ResumeWorkoutEvent event, Emitter<WorkoutTrackerState> emit) {
    _startTimer();

    if (state is WorkoutInProgress) {
      final currentState = state as WorkoutInProgress;
      emit(currentState.copyWith(isPaused: false));
    }
  }

  void _onCompleteExercise(CompleteExerciseEvent event, Emitter<WorkoutTrackerState> emit) {
    if (state is WorkoutInProgress) {
      final currentState = state as WorkoutInProgress;
      final completedExercises = List<String>.from(currentState.completedExercises)
        ..add(currentState.workout.exercises[currentState.currentExerciseIndex].id);

      final nextIndex = currentState.currentExerciseIndex + 1;

      if (nextIndex >= currentState.workout.exercises.length) {
        add(CompleteWorkoutEvent());
      } else {
        emit(currentState.copyWith(
          currentExerciseIndex: nextIndex,
          completedExercises: completedExercises,
        ));
      }
    }
  }

  void _onSkipExercise(SkipExerciseEvent event, Emitter<WorkoutTrackerState> emit) {
    if (state is WorkoutInProgress) {
      final currentState = state as WorkoutInProgress;
      final nextIndex = currentState.currentExerciseIndex + 1;

      if (nextIndex >= currentState.workout.exercises.length) {
        add(CompleteWorkoutEvent());
      } else {
        emit(currentState.copyWith(currentExerciseIndex: nextIndex));
      }
    }
  }

  void _onStartRestTimer(StartRestTimerEvent event, Emitter<WorkoutTrackerState> emit) {
    if (state is WorkoutInProgress) {
      final currentState = state as WorkoutInProgress;
      emit(currentState.copyWith(
        isResting: true,
        restSeconds: event.seconds,
      ));
    }
  }

  void _onSkipRest(SkipRestEvent event, Emitter<WorkoutTrackerState> emit) {
    if (state is WorkoutInProgress) {
      final currentState = state as WorkoutInProgress;
      emit(currentState.copyWith(isResting: false, restSeconds: 0));
    }
  }

  void _onCompleteWorkout(CompleteWorkoutEvent event, Emitter<WorkoutTrackerState> emit) {
    _workoutTimer?.cancel();

    if (state is WorkoutInProgress) {
      final currentState = state as WorkoutInProgress;
      emit(WorkoutCompleted(
        workout: currentState.workout,
        totalSeconds: _elapsedSeconds,
        completedExercises: currentState.completedExercises,
      ));
    }
  }

  void _onUpdateTimer(UpdateTimerEvent event, Emitter<WorkoutTrackerState> emit) {
    _elapsedSeconds++;

    if (state is WorkoutInProgress) {
      final currentState = state as WorkoutInProgress;

      if (currentState.isResting && currentState.restSeconds > 0) {
        final newRestSeconds = currentState.restSeconds - 1;
        if (newRestSeconds <= 0) {
          emit(currentState.copyWith(
            elapsedSeconds: _elapsedSeconds,
            isResting: false,
            restSeconds: 0,
          ));
        } else {
          emit(currentState.copyWith(
            elapsedSeconds: _elapsedSeconds,
            restSeconds: newRestSeconds,
          ));
        }
      } else {
        emit(currentState.copyWith(elapsedSeconds: _elapsedSeconds));
      }
    }
  }

  void _startTimer() {
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(UpdateTimerEvent());
    });
  }

  @override
  Future<void> close() {
    _workoutTimer?.cancel();
    return super.close();
  }
}