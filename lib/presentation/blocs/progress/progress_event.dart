
part of 'progress_bloc.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object> get props => [];
}

class FetchProgressHistory extends ProgressEvent {
  final String userId;

  const FetchProgressHistory({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddNewProgressEntry extends ProgressEvent {
  final Progress progress;

  const AddNewProgressEntry({required this.progress});

  @override
  List<Object> get props => [progress];
}

class UpdateProgressEntry extends ProgressEvent {
  final Progress progress;

  const UpdateProgressEntry({required this.progress});

  @override
  List<Object> get props => [progress];
}

class DeleteProgressEntry extends ProgressEvent {
  final String progressId;

  const DeleteProgressEntry({required this.progressId});

  @override
  List<Object> get props => [progressId];
}

class FilterProgressByDateRange extends ProgressEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;

  const FilterProgressByDateRange({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [userId, startDate, endDate];
}
