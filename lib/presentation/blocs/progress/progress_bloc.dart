
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/progress.dart';
import '../../../domain/usecases/progress/get_progress_history_usecase.dart';
import '../../../domain/usecases/progress/add_progress_entry_usecase.dart';

part 'progress_event.dart';
part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetProgressHistoryUseCase getProgressHistory;
  final AddProgressEntryUseCase addProgressEntry;

  ProgressBloc({
    required this.getProgressHistory,
    required this.addProgressEntry,
  }) : super(ProgressInitial()) {
    on<FetchProgressHistory>(_onFetchProgressHistory);
    on<AddNewProgressEntry>(_onAddNewProgressEntry);
  }

  Future<void> _onFetchProgressHistory(
    FetchProgressHistory event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());
    final result = await getProgressHistory(event.userId);
    result.fold(
      (failure) => emit(ProgressError(message: _mapFailureToMessage(failure))),
      (progressList) => emit(ProgressLoaded(progressList: progressList)),
    );
  }

  Future<void> _onAddNewProgressEntry(
    AddNewProgressEntry event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());
    final result = await addProgressEntry(event.progress);
    result.fold(
      (failure) => emit(ProgressError(message: _mapFailureToMessage(failure))),
      (progress) => add(FetchProgressHistory(userId: progress.userId)),
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    // Map failures to user-friendly messages
    return 'Failed to load progress data. Please try again.';
  }
}
