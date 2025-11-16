
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int? age;
  final double? weight;
  final double? height;
  final String? gender;
  final String? fitnessGoal;
  final String? activityLevel;
  final DateTime? createdAt;
  final bool isPremium;
  final int? dailyCalorieGoal;
  final int? dailyProteinGoal;
  final int? dailyCarbsGoal;
  final int? dailyFatGoal;
  final int? dailyWaterGoal;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.age,
    this.weight,
    this.height,
    this.gender,
    this.fitnessGoal,
    this.activityLevel,
    this.createdAt,
    this.isPremium = false,
    this.dailyCalorieGoal,
    this.dailyProteinGoal,
    this.dailyCarbsGoal,
    this.dailyFatGoal,
    this.dailyWaterGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'fitnessGoal': fitnessGoal,
      'activityLevel': activityLevel,
      'createdAt': createdAt?.toIso8601String(),
      'isPremium': isPremium,
      'dailyCalorieGoal': dailyCalorieGoal,
      'dailyProteinGoal': dailyProteinGoal,
      'dailyCarbsGoal': dailyCarbsGoal,
      'dailyFatGoal': dailyFatGoal,
      'dailyWaterGoal': dailyWaterGoal,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      age: json['age'],
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      gender: json['gender'],
      fitnessGoal: json['fitnessGoal'],
      activityLevel: json['activityLevel'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      isPremium: json['isPremium'] ?? false,
      dailyCalorieGoal: json['dailyCalorieGoal'],
      dailyProteinGoal: json['dailyProteinGoal'],
      dailyCarbsGoal: json['dailyCarbsGoal'],
      dailyFatGoal: json['dailyFatGoal'],
      dailyWaterGoal: json['dailyWaterGoal'],
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    int? age,
    double? weight,
    double? height,
    String? gender,
    String? fitnessGoal,
    String? activityLevel,
    DateTime? createdAt,
    bool? isPremium,
    int? dailyCalorieGoal,
    int? dailyProteinGoal,
    int? dailyCarbsGoal,
    int? dailyFatGoal,
    int? dailyWaterGoal,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      dailyProteinGoal: dailyProteinGoal ?? this.dailyProteinGoal,
      dailyCarbsGoal: dailyCarbsGoal ?? this.dailyCarbsGoal,
      dailyFatGoal: dailyFatGoal ?? this.dailyFatGoal,
      dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
    );
  }

  @override
  List<Object?> get props => [
    id, name, email, photoUrl, age, weight, height, 
    gender, fitnessGoal, activityLevel, createdAt, isPremium,
    dailyCalorieGoal, dailyProteinGoal, dailyCarbsGoal, 
    dailyFatGoal, dailyWaterGoal
  ];
}
