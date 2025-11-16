
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

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? videoUrl,
    int? sets,
    int? reps,
    int? duration,
    String? equipment,
    String? category,
    String? muscleGroup,
    List<String>? instructions,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
      equipment: equipment ?? this.equipment,
      category: category ?? this.category,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  List<Object?> get props => [
    id, name, description, imageUrl, videoUrl, 
    sets, reps, duration, equipment, category,
    muscleGroup, instructions
  ];
}
