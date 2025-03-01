
import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final int points;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0
  final AchievementCategory category;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.points,
    required this.isUnlocked,
    this.unlockedAt,
    required this.progress,
    required this.category,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? iconUrl,
    int? points,
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
    AchievementCategory? category,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      points: points ?? this.points,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        iconUrl,
        points,
        isUnlocked,
        unlockedAt,
        progress,
        category,
      ];
}

enum AchievementCategory {
  workout,
  nutrition,
  progress,
  community,
  special,
}
import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool isUnlocked;
  final int progress; // 0-100
  final String? progressDescription;
  final DateTime? dateUnlocked;
  final String? iconPath;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.isUnlocked,
    required this.progress,
    this.progressDescription,
    this.dateUnlocked,
    this.iconPath,
  });

  @override
  List<Object?> get props => [
    id, 
    name, 
    description, 
    category, 
    isUnlocked, 
    progress, 
    progressDescription, 
    dateUnlocked,
    iconPath,
  ];
}
