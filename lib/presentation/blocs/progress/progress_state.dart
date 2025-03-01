
part of 'progress_bloc.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();
  
  @override
  List<Object> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final List<Progress> progressList;

  const ProgressLoaded({required this.progressList});

  @override
  List<Object> get props => [progressList];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProgressEntryAdded extends ProgressState {
  final Progress progress;

  const ProgressEntryAdded({required this.progress});

  @override
  List<Object> get props => [progress];
}

class ProgressEntryUpdated extends ProgressState {
  final Progress progress;

  const ProgressEntryUpdated({required this.progress});

  @override
  List<Object> get props => [progress];
}

class ProgressEntryDeleted extends ProgressState {
  final String id;

  const ProgressEntryDeleted({required this.id});

  @override
  List<Object> get props => [id];
}
