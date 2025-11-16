import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String criteria;
  final int xpPoints;
  final DateTime? dateEarned;
  final String? iconUrl; // Added from the first definition
  final int points; // Added from the first definition
  final bool isUnlocked; // Added from the first definition
  final DateTime? unlockedAt; // Added from the first definition
  final double progress; // Added from the first definition (0.0 to 1.0)
  final AchievementCategory? category; // Added from the first definition

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.criteria,
    required this.xpPoints,
    this.dateEarned,
    this.iconUrl,
    this.points = 0, // Default value
    this.isUnlocked = false, // Default value
    this.unlockedAt,
    this.progress = 0.0, // Default value
    this.category,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        criteria,
        xpPoints,
        dateEarned,
        iconUrl,
        points,
        isUnlocked,
        unlockedAt,
        progress,
        category,
      ];

  bool get isEarned => dateEarned != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'criteria': criteria,
      'xpPoints': xpPoints,
      'dateEarned': dateEarned?.toIso8601String(),
      'iconUrl': iconUrl,
      'points': points,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
      'category': category?.name, // Store enum name
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      criteria: map['criteria'],
      xpPoints: map['xpPoints'] ?? 0, // Default if not present
      dateEarned: map['dateEarned'] != null ? DateTime.parse(map['dateEarned']) : null,
      iconUrl: map['iconUrl'],
      points: map['points'] ?? 0, // Default if not present
      isUnlocked: map['isUnlocked'] ?? false, // Default if not present
      unlockedAt: map['unlockedAt'] != null ? DateTime.parse(map['unlockedAt']) : null,
      progress: map['progress'] ?? 0.0, // Default if not present
      category: map['category'] != null ? AchievementCategory.values.firstWhere((e) => e.name == map['category'], orElse: () => AchievementCategory.special) : null, // Handle enum conversion
    );
  }

  // Add copyWith method from the first definition
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
    String? imageUrl,
    String? criteria,
    int? xpPoints,
    DateTime? dateEarned,
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
      imageUrl: imageUrl ?? this.imageUrl,
      criteria: criteria ?? this.criteria,
      xpPoints: xpPoints ?? this.xpPoints,
      dateEarned: dateEarned ?? this.dateEarned,
    );
  }
}

// Enum from the first definition
enum AchievementCategory {
  workout,
  nutrition,
  progress,
  community,
  special,
}

class AchievementProgress extends Equatable {
  final Achievement achievement;
  final double progress; // Value between 0.0 and 1.0
  final int currentValue;
  final int targetValue;

  const AchievementProgress({
    required this.achievement,
    required this.progress,
    required this.currentValue,
    required this.targetValue,
  });

  @override
  List<Object> get props => [achievement, progress, currentValue, targetValue];

  AchievementProgress copyWith({
    Achievement? achievement,
    double? progress,
    int? currentValue,
    int? targetValue,
  }) {
    return AchievementProgress(
      achievement: achievement ?? this.achievement,
      progress: progress ?? this.progress,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
    );
  }

  bool get isCompleted => progress >= 1.0;
}