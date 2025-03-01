
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

  @override
  List<Object?> get props => [id, imageUrl, date, type, weight, bodyFat, notes];
}
