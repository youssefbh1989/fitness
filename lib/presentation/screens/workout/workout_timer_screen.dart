
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

class WorkoutTimerScreen extends StatefulWidget {
  const WorkoutTimerScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  bool _isRunning = false;
  int _seconds = 0;
  late Timer _timer;
  final List<Map<String, dynamic>> _exercises = [
    {
      'name': 'Push-ups',
      'sets': 3,
      'reps': 15,
      'isCompleted': false,
    },
    {
      'name': 'Squats',
      'sets': 4,
      'reps': 20,
      'isCompleted': false,
    },
    {
      'name': 'Plank',
      'sets': 3,
      'duration': '60 sec',
      'isCompleted': false,
    },
    {
      'name': 'Lunges',
      'sets': 3,
      'reps': 12,
      'isCompleted': false,
    },
    {
      'name': 'Burpees',
      'sets': 3,
      'reps': 10,
      'isCompleted': false,
    },
  ];
  int _currentExerciseIndex = 0;

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startTimer();
      } else {
        _timer.cancel();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _seconds = 0;
      if (_isRunning) {
        _timer.cancel();
        _isRunning = false;
      }
    });
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    
    final hoursStr = hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : '';
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');
    
    return '$hoursStr$minutesStr:$secondsStr';
  }

  void _completeExercise(int index) {
    setState(() {
      _exercises[index]['isCompleted'] = !_exercises[index]['isCompleted'];
      
      // If all exercises are completed
      if (_exercises.every((exercise) => exercise['isCompleted'])) {
        if (_isRunning) {
          _timer.cancel();
          _isRunning = false;
        }
        
        // Show completion dialog
        Future.delayed(const Duration(milliseconds: 300), () {
          _showCompletionDialog();
        });
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Workout Completed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.celebration,
                size: 64,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              Text(
                'Great job! You completed your workout in ${_formatTime(_seconds)}.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/save-workout');
              },
              child: const Text('Save Results'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Workout Timer',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _buildTimerSection(),
          Expanded(
            child: _buildExercisesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          Text(
            _formatTime(_seconds),
            style: Theme.of(context).textTheme.headline2?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _toggleTimer,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_isRunning ? 'Pause' : 'Start'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _resetTimer,
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: 'Reset Timer',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _exercises.length,
      itemBuilder: (context, index) {
        final exercise = _exercises[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: exercise['isCompleted']
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              child: Icon(
                exercise['isCompleted'] ? Icons.check : Icons.fitness_center,
                color: exercise['isCompleted']
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              exercise['name'],
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.bold,
                decoration: exercise['isCompleted']
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: Text(
              exercise['duration'] != null
                  ? '${exercise['sets']} sets x ${exercise['duration']}'
                  : '${exercise['sets']} sets x ${exercise['reps']} reps',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                decoration: exercise['isCompleted']
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                exercise['isCompleted'] ? Icons.refresh : Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => _completeExercise(index),
            ),
          ),
        );
      },
    );
  }
}
