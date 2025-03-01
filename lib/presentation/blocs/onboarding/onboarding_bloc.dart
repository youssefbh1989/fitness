
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial(pageIndex: 0)) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingCompleted>(_onCompleted);
    on<CheckOnboardingStatus>(_checkStatus);
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingInitial(pageIndex: event.pageIndex));
  }

  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    emit(const OnboardingFinished());
  }

  Future<void> _checkStatus(
    CheckOnboardingStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;
    
    if (completed) {
      emit(const OnboardingFinished());
    } else {
      emit(const OnboardingInitial(pageIndex: 0));
    }
  }
}
