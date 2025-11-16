import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final int? age;
  final double? weight;
  final double? height;
  final String? gender;
  final List<String>? goals;
  final String? fitnessLevel;
  final bool isPremium;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.age,
    this.weight,
    this.height,
    this.gender,
    this.goals,
    this.fitnessLevel,
    this.isPremium = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    int? age,
    double? weight,
    double? height,
    String? gender,
    List<String>? goals,
    String? fitnessLevel,
    bool? isPremium,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      goals: goals ?? this.goals,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'goals': goals,
      'fitnessLevel': fitnessLevel,
      'isPremium': isPremium,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
      gender: json['gender'],
      goals: json['goals'] != null ? List<String>.from(json['goals']) : null,
      fitnessLevel: json['fitnessLevel'],
      isPremium: json['isPremium'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
    id, name, email, profileImageUrl, age, weight, 
    height, gender, goals, fitnessLevel, isPremium
  ];
}