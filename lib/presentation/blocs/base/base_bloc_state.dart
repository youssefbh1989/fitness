
import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();
  
  @override
  List<Object?> get props => [];
}

class InitialState extends BaseState {}

class LoadingState extends BaseState {}

class LoadedState<T> extends BaseState {
  final T data;
  
  const LoadedState(this.data);
  
  @override
  List<Object?> get props => [data];
}

class ErrorState extends BaseState {
  final String message;
  
  const ErrorState(this.message);
  
  @override
  List<Object?> get props => [message];
}
