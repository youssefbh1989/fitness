
import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type; // workout, nutrition, progress, etc.
  final String? relatedItemId; // ID of related workout, meal plan, etc.

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
    this.relatedItemId,
  });

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? type,
    String? relatedItemId,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      relatedItemId: relatedItemId ?? this.relatedItemId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        timestamp,
        isRead,
        type,
        relatedItemId,
      ];
}
