
import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String? videoUrl;
  final int sets;
  final int reps;
  final int? duration; // in seconds
  final String equipment;
  final String? category;
  final String? muscleGroup;
  final List<String>? instructions;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.videoUrl,
    required this.sets,
    required this.reps,
    this.duration,
    required this.equipment,
    this.category,
    this.muscleGroup,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'equipment': equipment,
      'category': category,
      'muscleGroup': muscleGroup,
      'instructions': instructions,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      sets: json['sets'],
      reps: json['reps'],
      duration: json['duration'],
      equipment: json['equipment'],
      category: json['category'],
      muscleGroup: json['muscleGroup'],
      instructions: json['instructions'] != null 
          ? List<String>.from(json['instructions']) 
          : null,
    );
  }

  @override
  List<Object?> get props => [
    id, name, description, imageUrl, videoUrl, 
    sets, reps, duration, equipment, category,
    muscleGroup, instructions
  ];
}
