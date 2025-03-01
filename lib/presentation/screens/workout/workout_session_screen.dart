
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/entities/exercise.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutSessionScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _currentExerciseIndex = 0;
  late Exercise _currentExercise;
  
  // Timer state
  bool _isResting = false;
  bool _isPaused = false;
  int _timerSeconds = 0;
  int _totalTimeSeconds = 0;
  late Timer _timer;
  
  // Exercise state
  int _currentSet = 1;
  
  @override
  void initState() {
    super.initState();
    _currentExercise = widget.workout.exercises[_currentExerciseIndex];
    _startWorkout();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startWorkout() {
    // Start the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _timerSeconds = _isResting 
              ? _timerSeconds - 1 
              : _timerSeconds + 1;
          _totalTimeSeconds += 1;
          
          // If rest timer reaches 0, move to next set or exercise
          if (_isResting && _timerSeconds <= 0) {
            _isResting = false;
            if (_currentSet >= _currentExercise.sets) {
              _moveToNextExercise();
            } else {
              _currentSet++;
            }
          }
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _startRest() {
    setState(() {
      _isResting = true;
      _timerSeconds = _currentExercise.duration; // Rest duration from exercise
    });
  }

  void _skipRest() {
    setState(() {
      _isResting = false;
      if (_currentSet >= _currentExercise.sets) {
        _moveToNextExercise();
      } else {
        _currentSet++;
      }
    });
  }

  void _moveToNextExercise() {
    if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentExercise = widget.workout.exercises[_currentExerciseIndex];
        _currentSet = 1;
      });
    } else {
      _completeWorkout();
    }
  }

  void _moveToPreviousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _currentExercise = widget.workout.exercises[_currentExerciseIndex];
        _currentSet = 1;
      });
    }
  }

  void _completeWorkout() {
    _timer.cancel();
    
    // Navigate to workout summary
    Navigator.of(context).pushReplacementNamed(
      '/workout_summary',
      arguments: {
        'workout': widget.workout,
        'timeInSeconds': _totalTimeSeconds,
        'completedExercises': widget.workout.exercises.length,
      },
    );
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog() ?? false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isResting 
                    ? _buildRestView() 
                    : _buildExerciseView(),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth! * 0.05,
        vertical: SizeConfig.screenHeight! * 0.02,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showExitDialog(),
          ),
          Column(
            children: [
              Text(
                widget.workout.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Exercise ${_currentExerciseIndex + 1}/${widget.workout.exercises.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Text(
            _formatTime(_totalTimeSeconds),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            _currentExercise.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Set $_currentSet of ${_currentExercise.sets}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              _currentExercise.imageUrl,
              height: SizeConfig.screenHeight! * 0.25,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: SizeConfig.screenHeight! * 0.25,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.fitness_center, size: 80, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoBox('Reps', '${_currentExercise.reps}', Icons.repeat),
              _buildInfoBox('Rest', '${_currentExercise.duration}s', Icons.timer),
              _buildInfoBox(
                'Target', 
                _currentExercise.targetMuscle ?? 'Body', 
                Icons.fitness_center
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _currentExercise.instructions ?? 'Perform the exercise with proper form.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'REST',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_timerSeconds),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'seconds',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Next: ${_currentSet < _currentExercise.sets ? 'Set ${_currentSet + 1}' : 'Next Exercise'}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _skipRest,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('SKIP REST'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String title, String value, IconData icon) {
    return Container(
      width: SizeConfig.screenWidth! * 0.25,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _currentExerciseIndex > 0 ? _moveToPreviousExercise : null,
              color: _currentExerciseIndex > 0 ? null : Colors.grey,
            ),
            if (!_isResting) ...[
              ElevatedButton(
                onPressed: _isPaused ? _togglePause : _startRest,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: _isPaused 
                      ? Colors.green 
                      : Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(_isPaused ? 'RESUME' : 'COMPLETE SET'),
              ),
            ] else ...[
              const SizedBox(width: 120), // Placeholder when in rest mode
            ],
            IconButton(
              icon: _isPaused 
                  ? const Icon(Icons.play_arrow) 
                  : const Icon(Icons.pause),
              onPressed: !_isResting ? _togglePause : null,
              color: !_isResting ? null : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quit Workout?'),
        content: const Text('Are you sure you want to quit this workout? Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.of(context).pop();
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}
