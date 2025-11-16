
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../../domain/usecases/user/update_user_profile_usecase.dart';

// Events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class GetUserProfileEvent extends UserEvent {
  const GetUserProfileEvent();
}

class UpdateUserProfileEvent extends UserEvent {
  final User user;
  const UpdateUserProfileEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class LogOutEvent extends UserEvent {}

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  const UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;
  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
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

  Future<void> _onGetUserProfile(GetUserProfileEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    
    final result = await getUserProfileUseCase();
    
    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> _onUpdateUserProfile(UpdateUserProfileEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    
    final result = await updateUserProfileUseCase(event.user);
    
    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<UserState> emit) async {
    emit(UserInitial());
  }
}
