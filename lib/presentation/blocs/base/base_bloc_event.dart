
import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  const BaseEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadEvent extends BaseEvent {}

class RefreshEvent extends BaseEvent {}
