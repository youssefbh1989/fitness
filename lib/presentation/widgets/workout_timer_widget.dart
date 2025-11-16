
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/workout_tracker/workout_tracker_bloc.dart';
import '../blocs/workout_tracker/workout_tracker_state.dart';
import '../blocs/workout_tracker/workout_tracker_event.dart';

class WorkoutTimerWidget extends StatelessWidget {
  const WorkoutTimerWidget({Key? key}) : super(key: key);

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutTrackerBloc, WorkoutTrackerState>(
      builder: (context, state) {
        if (state is! WorkoutInProgress) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                _formatTime(state.elapsedSeconds),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (state.isResting) ...[
                Text(
                  'Rest Time',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(state.restSeconds),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!state.isResting) ...[
                    IconButton(
                      onPressed: () {
                        if (state.isPaused) {
                          context.read<WorkoutTrackerBloc>().add(ResumeWorkoutEvent());
                        } else {
                          context.read<WorkoutTrackerBloc>().add(PauseWorkoutEvent());
                        }
                      },
                      icon: Icon(
                        state.isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ] else ...[
                    IconButton(
                      onPressed: () {
                        context.read<WorkoutTrackerBloc>().add(SkipRestEvent());
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
