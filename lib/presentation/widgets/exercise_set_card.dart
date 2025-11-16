
import 'package:flutter/material.dart';
import '../../domain/entities/exercise_set.dart';

class ExerciseSetCard extends StatelessWidget {
  final ExerciseSet exerciseSet;
  final int setNumber;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ExerciseSetCard({
    Key? key,
    required this.exerciseSet,
    required this.setNumber,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: exerciseSet.isCompleted ? 0 : 1,
      color: exerciseSet.isCompleted
          ? Colors.green.withOpacity(0.1)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: exerciseSet.isCompleted
              ? Colors.green
              : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Set number
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: exerciseSet.isCompleted
                    ? Colors.green
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$setNumber',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: exerciseSet.isCompleted
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Weight and reps
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${exerciseSet.weight} kg',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.repeat,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${exerciseSet.reps} reps',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (exerciseSet.restTime != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Rest: ${exerciseSet.restTime}s',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (exerciseSet.notes != null &&
                      exerciseSet.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      exerciseSet.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                    color: Colors.grey[700],
                  ),
                if (onToggleComplete != null)
                  IconButton(
                    icon: Icon(
                      exerciseSet.isCompleted
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      size: 24,
                    ),
                    onPressed: onToggleComplete,
                    color: exerciseSet.isCompleted
                        ? Colors.green
                        : Colors.grey[400],
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: onDelete,
                    color: Colors.red[400],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
