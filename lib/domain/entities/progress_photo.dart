
import 'package:equatable/equatable.dart';

class ProgressPhoto extends Equatable {
  final String id;
  final String imageUrl;
  final DateTime date;
  final String type; // 'front', 'side', 'back'
  final double? weight;
  final double? bodyFat;
  final String? notes;

  const ProgressPhoto({
    required this.id,
    required this.imageUrl,
    required this.date,
    required this.type,
    this.weight,
    this.bodyFat,
    this.notes,
  });

  ProgressPhoto copyWith({
    String? id,
    String? imageUrl,
    DateTime? date,
    String? type,
    double? weight,
    double? bodyFat,
    String? notes,
  }) {
    return ProgressPhoto(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      type: type ?? this.type,
      weight: weight ?? this.weight,
      bodyFat: bodyFat ?? this.bodyFat,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'type': type,
      'weight': weight,
      'bodyFat': bodyFat,
      'notes': notes,
    };
  }

  factory ProgressPhoto.fromJson(Map<String, dynamic> json) {
    return ProgressPhoto(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      weight: json['weight'] as double?,
      bodyFat: json['bodyFat'] as double?,
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, imageUrl, date, type, weight, bodyFat, notes];
}
