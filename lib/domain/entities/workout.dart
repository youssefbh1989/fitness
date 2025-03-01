
import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String level;
  final int duration; // minutes
  final List<Exercise> exercises;
  final String category;
  final bool isPremium;
  
  const Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.level,
    required this.duration,
    required this.exercises,
    required this.category,
    this.isPremium = false,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'level': level,
      'duration': duration,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'category': category,
      'isPremium': isPremium,
    };
  }
  
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      level: json['level'],
      duration: json['duration'],
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
      category: json['category'],
      isPremium: json['isPremium'] ?? false,
    );
  }
  
  @override
  List<Object?> get props => [
    id, title, description, imageUrl, level, 
    duration, exercises, category, isPremium
  ];
}

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String? videoUrl;
  final int sets;
  final int reps;
  final int? duration; // seconds
  final String equipment;
  
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
    );
  }
  
  @override
  List<Object?> get props => [
    id, name, description, imageUrl, videoUrl, 
    sets, reps, duration, equipment
  ];
}
import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int? sets;
  final int? reps;
  final int? duration; // in seconds
  final String equipment;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.sets,
    this.reps,
    this.duration,
    required this.equipment,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, sets, reps, duration, equipment];
}

class Workout extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String level;
  final int duration; // in minutes
  final String category;
  final List<Exercise> exercises;

  const Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.level,
    required this.duration,
    required this.category,
    required this.exercises,
  });
  
  @override
  List<Object> get props => [id, title, description, imageUrl, level, duration, category, exercises];
}
import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int duration;
  final String difficulty;
  final List<Exercise> exercises;
  final bool isFavorite;

  const Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.difficulty,
    required this.exercises,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
    id, 
    title, 
    description, 
    imageUrl, 
    duration, 
    difficulty, 
    exercises, 
    isFavorite
  ];
}

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int sets;
  final int reps;
  final int restTime;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.sets,
    required this.reps,
    required this.restTime,
  });

  @override
  List<Object?> get props => [
    id, 
    name, 
    description, 
    imageUrl, 
    sets, 
    reps, 
    restTime
  ];
}
import 'exercise.dart';

class Workout {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String difficulty;
  final int duration;
  final int calories;
  final bool isFavorite;
  final List<String>? equipment;
  final List<Exercise> exercises;
  
  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.difficulty,
    required this.duration,
    required this.calories,
    required this.isFavorite,
    this.equipment,
    required this.exercises,
  });
  
  Workout copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? difficulty,
    int? duration,
    int? calories,
    bool? isFavorite,
    List<String>? equipment,
    List<Exercise>? exercises,
  }) {
    return Workout(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      calories: calories ?? this.calories,
      isFavorite: isFavorite ?? this.isFavorite,
      equipment: equipment ?? this.equipment,
      exercises: exercises ?? this.exercises,
    );
  }
}
import 'exercise.dart';

class Workout {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int difficulty; // 1-3 (beginner, intermediate, advanced)
  final int duration; // in minutes
  final List<Exercise> exercises;
  final List<String> equipment;
  final int caloriesBurn;
  final double rating;
  final bool isFavorite;
  final String category;
  final String trainer;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.difficulty,
    required this.duration,
    required this.exercises,
    required this.equipment,
    required this.caloriesBurn,
    required this.rating,
    this.isFavorite = false,
    required this.category,
    required this.trainer,
  });

  Workout copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? difficulty,
    int? duration,
    List<Exercise>? exercises,
    List<String>? equipment,
    int? caloriesBurn,
    double? rating,
    bool? isFavorite,
    String? category,
    String? trainer,
  }) {
    return Workout(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      exercises: exercises ?? this.exercises,
      equipment: equipment ?? this.equipment,
      caloriesBurn: caloriesBurn ?? this.caloriesBurn,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      trainer: trainer ?? this.trainer,
    );
  }
}
