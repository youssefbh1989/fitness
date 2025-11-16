
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/exercise_set.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/repositories/workout_repository.dart';

part 'workout_tracker_event.dart';
part 'workout_tracker_state.dart';

class WorkoutTrackerBloc extends Bloc<WorkoutTrackerEvent, WorkoutTrackerState> {
  final WorkoutRepository workoutRepository;
  Timer? _workoutTimer;
  int _elapsedSeconds = 0;

  WorkoutTrackerBloc({required this.workoutRepository}) : super(WorkoutTrackerInitial()) {
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

  void _onCompleteWorkout(CompleteWorkoutEvent event, Emitter<WorkoutTrackerState> emit) async {
    _workoutTimer?.cancel();

    if (state is WorkoutInProgress) {
      final currentState = state as WorkoutInProgress;
      
      try {
        await workoutRepository.saveCompletedWorkout(
          workout: currentState.workout,
          duration: Duration(seconds: _elapsedSeconds),
          completedExercises: currentState.completedExercises,
        );
        
        emit(WorkoutCompleted(
          workout: currentState.workout,
          totalSeconds: _elapsedSeconds,
          completedExercises: currentState.completedExercises,
        ));
      } catch (e) {
        emit(WorkoutTrackerError(message: e.toString()));
      }
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
