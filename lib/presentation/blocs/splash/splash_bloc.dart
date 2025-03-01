
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/base/usecase.dart';
import '../../../domain/usecases/splash/check_first_time_usecase.dart';
import '../../../domain/usecases/splash/check_authenticated_usecase.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckFirstTimeUseCase checkFirstTimeUseCase;
  final CheckAuthenticatedUseCase checkAuthenticatedUseCase;

  SplashBloc({
    required this.checkFirstTimeUseCase,
    required this.checkAuthenticatedUseCase,
  }) : super(const SplashInitial()) {
    on<InitializeApp>(_onInitializeApp);
  }

  Future<void> _onInitializeApp(
    InitializeApp event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());
    
    // Check if it's the first time opening the app
    final firstTimeResult = await checkFirstTimeUseCase(NoParams());
    
    return firstTimeResult.fold(
      (failure) => emit(SplashError(failure.toString())),
      (isFirstTime) async {
        if (isFirstTime) {
          emit(const NavigateToOnboarding());
        } else {
          // Check if user is authenticated
          final authResult = await checkAuthenticatedUseCase(NoParams());
          
          return authResult.fold(
            (failure) => emit(SplashError(failure.toString())),
            (isAuthenticated) {
              if (isAuthenticated) {
                emit(const NavigateToHome());
              } else {
                emit(const NavigateToLogin());
              }
            },
          );
        }
      },
    );
  }
}
