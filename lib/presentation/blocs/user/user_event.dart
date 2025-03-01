
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserEvent {
  final String userId;

  const LoadUserProfile({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateUserProfile extends UserEvent {
  final String userId;
  final String? name;
  final String? email;
  final String? profilePicture;
  final int? age;
  final double? weight;
  final double? height;
  final String? fitnessGoal;

  const UpdateUserProfile({
    required this.userId,
    this.name,
    this.email,
    this.profilePicture,
    this.age,
    this.weight,
    this.height,
    this.fitnessGoal,
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    profilePicture,
    age,
    weight,
    height,
    fitnessGoal,
  ];
}
part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserProfileEvent extends UserEvent {}

class UpdateUserProfileEvent extends UserEvent {
  final User user;

  const UpdateUserProfileEvent(this.user);

  @override
  List<Object> get props => [user];
}

class LogOutEvent extends UserEvent {}
