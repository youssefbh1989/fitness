
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  final int pageIndex;

  const OnboardingInitial({required this.pageIndex});

  @override
  List<Object?> get props => [pageIndex];
}

class OnboardingFinished extends OnboardingState {
  const OnboardingFinished();
}
