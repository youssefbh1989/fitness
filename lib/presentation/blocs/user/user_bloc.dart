import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../../domain/usecases/user/update_user_profile_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  UserBloc({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(UserInitial()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<LogOutEvent>(_onLogOut);
  }

  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await getUserProfileUseCase(NoParams());
    result.fold(
      (failure) => emit(UserError(message: _mapFailureToMessage(failure))),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await updateUserProfileUseCase(event.user);
    result.fold(
      (failure) => emit(UserError(message: _mapFailureToMessage(failure))),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> _onLogOut(
    LogOutEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserInitial());
    // Additional logout logic can be added here
  }

  String _mapFailureToMessage(Failure failure) {
    // Map different failure types to appropriate messages
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error';
      case CacheFailure:
        return 'Cache error';
      default:
        return 'Unexpected error';
    }
  }
}