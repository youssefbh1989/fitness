
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/size_config.dart';
import '../../blocs/onboarding/onboarding_bloc.dart';
import '../../blocs/onboarding/onboarding_event.dart';
import '../../blocs/onboarding/onboarding_state.dart';
import '../../routes/app_router.dart';
import 'onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  
  final List<OnboardingContent> contents = [
    OnboardingContent(
      image: Assets.onboarding1,
      title: 'Welcome to FitBody',
      description: 'Your personal fitness companion for a healthier lifestyle.',
    ),
    OnboardingContent(
      image: Assets.onboarding2,
      title: 'Custom Workout Plans',
      description: 'Get personalized workout plans based on your goals and fitness level.',
    ),
    OnboardingContent(
      image: Assets.onboarding3,
      title: 'Nutrition Guidance',
      description: 'Track your meals and get nutrition advice tailored to your needs.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingFinished) {
            Navigator.pushReplacementNamed(context, AppRouter.login);
          }
        },
        builder: (context, state) {
          if (state is OnboardingInitial) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        context.read<OnboardingBloc>().add(
                          OnboardingPageChanged(pageIndex: index),
                        );
                      },
                      itemCount: contents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                contents[index].image,
                                height: SizeConfig.screenHeight * 0.35,
                              ),
                              const SizedBox(height: 30),
                              Text(
                                contents[index].title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                contents[index].description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            contents.length,
                            (index) => buildDot(index, state.pageIndex),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (state.pageIndex == contents.length - 1) {
                                  context.read<OnboardingBloc>().add(OnboardingCompleted());
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                state.pageIndex == contents.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Container buildDot(int index, int currentPage) {
    return Container(
      height: 10,
      width: currentPage == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentPage == index
            ? AppTheme.primaryColor
            : Colors.grey.withOpacity(0.5),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../routes/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to FitBody',
      'description': 'Your personal fitness companion for a healthier lifestyle',
      'image': Assets.onboarding1,
    },
    {
      'title': 'Track Your Progress',
      'description': 'Monitor your workouts, nutrition, and body metrics all in one place',
      'image': Assets.onboarding2,
    },
    {
      'title': 'Join the Community',
      'description': 'Connect with like-minded fitness enthusiasts and share your journey',
      'image': Assets.onboarding3,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }

  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _numPages; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _numPages,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Image.asset(
                            _onboardingData[index]['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          _onboardingData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _onboardingData[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                children: [
                  _buildPageIndicator(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentPage > 0
                          ? TextButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text('Back'),
                            )
                          : const SizedBox(width: 80),
                      _currentPage < _numPages - 1
                          ? ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0,
                                  vertical: 15.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text('Next'),
                            )
                          : ElevatedButton(
                              onPressed: _completeOnboarding,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0,
                                  vertical: 15.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text('Get Started'),
                            ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_currentPage < _numPages - 1)
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: const Text('Skip'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/constants/assets.dart';
import '../../routes/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Track Your Workouts',
      'description': 'Record your exercises, sets, reps, and weights to track your progress over time.',
      'image': Assets.onboardingBg1,
    },
    {
      'title': 'Nutrition Planning',
      'description': 'Create meal plans that align with your fitness goals and track your daily intake.',
      'image': Assets.onboardingBg2,
    },
    {
      'title': 'Join the Community',
      'description': 'Connect with fitness enthusiasts, share your progress, and stay motivated together.',
      'image': Assets.onboardingBg3,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(
                    title: _onboardingData[index]['title']!,
                    description: _onboardingData[index]['description']!,
                    image: _onboardingData[index]['image']!,
                  );
                },
              ),
            ),
            _buildPageIndicator(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required String image,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 300,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingData.length,
        (index) => Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_currentPage < _onboardingData.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pushNamed(context, AppRouter.userDetails);
              }
            },
            child: Text(_currentPage < _onboardingData.length - 1 ? 'Next' : 'Get Started'),
          ),
        ],
      ),
    );
  }
}
