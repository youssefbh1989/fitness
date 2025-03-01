
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
import 'dart:async';
import 'package:flutter/material.dart';
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
  // Current exercise index
  int _currentExerciseIndex = 0;
  
  // Current set for exercises
  int _currentSet = 1;
  
  // Timer for rest periods and timed exercises
  Timer? _timer;
  
  // Seconds remaining in current timer
  int _secondsRemaining = 0;
  
  // State of the workout
  bool _isResting = false;
  bool _isPaused = false;
  bool _isCompleted = false;
  
  // Stats tracking
  DateTime? _workoutStartTime;
  int _totalExercisesCompleted = 0;
  
  @override
  void initState() {
    super.initState();
    _workoutStartTime = DateTime.now();
    _setupExercise();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _setupExercise() {
    if (_currentExerciseIndex >= widget.workout.exercises.length) {
      _completeWorkout();
      return;
    }
    
    final exercise = widget.workout.exercises[_currentExerciseIndex];
    
    if (exercise.isRest) {
      _startRestTimer(exercise.duration);
    } else {
      // Reset the current set for new exercise
      _currentSet = 1;
    }
  }
  
  void _startRestTimer(int seconds) {
    setState(() {
      _isResting = true;
      _secondsRemaining = seconds;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;
      
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _isResting = false;
          
          // Move to next exercise after rest
          _moveToNextExercise();
        }
      });
    });
  }
  
  void _startSetRestTimer() {
    setState(() {
      _isResting = true;
      _secondsRemaining = widget.workout.exercises[_currentExerciseIndex].restTime;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;
      
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _isResting = false;
          
          if (_currentSet < widget.workout.exercises[_currentExerciseIndex].sets) {
            // More sets to go
            _currentSet++;
          } else {
            // All sets completed, move to next exercise
            _totalExercisesCompleted++;
            _moveToNextExercise();
          }
        }
      });
    });
  }
  
  void _moveToNextExercise() {
    _timer?.cancel();
    
    setState(() {
      _currentExerciseIndex++;
      _isResting = false;
    });
    
    _setupExercise();
  }
  
  void _completeSet() {
    final exercise = widget.workout.exercises[_currentExerciseIndex];
    
    if (_currentSet < exercise.sets) {
      // More sets to go, start rest timer
      _startSetRestTimer();
    } else {
      // All sets completed, move to next exercise
      _totalExercisesCompleted++;
      _moveToNextExercise();
    }
  }
  
  void _completeWorkout() {
    setState(() {
      _isCompleted = true;
    });
  }
  
  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }
  
  void _skipRest() {
    if (_isResting && _timer != null) {
      _timer?.cancel();
      
      setState(() {
        _isResting = false;
        
        if (_currentExerciseIndex < widget.workout.exercises.length && 
            widget.workout.exercises[_currentExerciseIndex].isRest) {
          // If we're skipping a rest exercise
          _moveToNextExercise();
        } else if (_currentSet < widget.workout.exercises[_currentExerciseIndex].sets) {
          // If we're skipping rest between sets
          _currentSet++;
        }
      });
    }
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  String _calculateWorkoutDuration() {
    if (_workoutStartTime == null) return '00:00';
    
    final now = _isCompleted ? DateTime.now() : DateTime.now();
    final difference = now.difference(_workoutStartTime!);
    
    final minutes = difference.inMinutes;
    final seconds = difference.inSeconds % 60;
    
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    if (_isCompleted) {
      return _buildCompletionScreen();
    }
    
    final exercise = _currentExerciseIndex < widget.workout.exercises.length
        ? widget.workout.exercises[_currentExerciseIndex]
        : null;
        
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: exercise != null
                  ? _isResting
                      ? _buildRestView(exercise)
                      : _buildExerciseView(exercise)
                  : const Center(child: CircularProgressIndicator()),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth! * 0.05,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _showExitDialog();
                },
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.workout.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Duration: ${_calculateWorkoutDuration()}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.fitness_center, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${_currentExerciseIndex + 1}/${widget.workout.exercises.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildExerciseView(Exercise exercise) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$_currentSet/${exercise.sets}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            exercise.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${exercise.sets} sets × ${exercise.reps} reps',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          if (exercise.imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                exercise.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported, color: Colors.white, size: 48),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(exercise.instructions),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isPaused ? null : _completeSet,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'COMPLETE SET $_currentSet',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRestView(Exercise exercise) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'REST TIME',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          exercise.isRest
              ? Text(
                  'Next: ${_currentExerciseIndex + 1 < widget.workout.exercises.length ? widget.workout.exercises[_currentExerciseIndex + 1].name : "Workout Complete"}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                )
              : Text(
                  'Next: Set $_currentSet of ${exercise.name}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  value: exercise.isRest
                      ? _secondsRemaining / exercise.duration
                      : _secondsRemaining / exercise.restTime,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    _formatTime(_secondsRemaining),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'seconds',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _isPaused ? null : _skipRest,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'SKIP REST',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: _currentExerciseIndex > 0
                ? () {
                    _timer?.cancel();
                    setState(() {
                      _currentExerciseIndex--;
                      _isResting = false;
                      _currentSet = 1;
                    });
                    _setupExercise();
                  }
                : null,
          ),
          FloatingActionButton(
            onPressed: _togglePause,
            child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: _currentExerciseIndex < widget.workout.exercises.length - 1
                ? () {
                    _timer?.cancel();
                    _moveToNextExercise();
                  }
                : null,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompletionScreen() {
    final workoutDuration = _workoutStartTime != null
        ? DateTime.now().difference(_workoutStartTime!)
        : const Duration();
        
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Workout Completed!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Great job! You\'ve completed the ${widget.workout.title}.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      _buildCompletionStat(
                        title: 'Duration',
                        value: '${workoutDuration.inMinutes} min',
                        icon: Icons.timer,
                      ),
                      const SizedBox(height: 16),
                      _buildCompletionStat(
                        title: 'Exercises',
                        value: '$_totalExercisesCompleted',
                        icon: Icons.fitness_center,
                      ),
                      const SizedBox(height: 16),
                      _buildCompletionStat(
                        title: 'Calories',
                        value: '${widget.workout.caloriesBurn}',
                        icon: Icons.local_fire_department,
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Share functionality
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('SHARE'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Save workout to history and return home
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            icon: const Icon(Icons.home),
                            label: const Text('FINISH'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCompletionStat({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Workout'),
          content: const Text(
            'Are you sure you want to exit this workout? Your progress will not be saved.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'EXIT',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
