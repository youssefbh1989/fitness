
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitbody/domain/entities/workout.dart';
import 'package:fitbody/domain/usecases/workout/get_workouts_usecase.dart';

// Events
abstract class WorkoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWorkoutsEvent extends WorkoutEvent {}

// States
abstract class WorkoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<Workout> workouts;

  WorkoutLoaded(this.workouts);

  @override
  List<Object?> get props => [workouts];
}

class WorkoutError extends WorkoutState {
  final String message;

  WorkoutError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final GetWorkoutsUseCase getWorkoutsUseCase;

  WorkoutBloc({
    required this.getWorkoutsUseCase,
  }) : super(WorkoutInitial()) {
    on<FetchWorkoutsEvent>(_onFetchWorkouts);
  }

  Future<void> _onFetchWorkouts(FetchWorkoutsEvent event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    
    final result = await getWorkoutsUseCase();
    
    result.fold(
      (failure) => emit(WorkoutError('Failed to load workouts. Please try again.')),
      (workouts) => emit(WorkoutLoaded(workouts)),
    );
  }
}
