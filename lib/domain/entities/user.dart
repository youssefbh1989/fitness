
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
  final int? activityLevel;
  
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
  });
  
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
    int? activityLevel,
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
    );
  }
  
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
    };
  }
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
      gender: json['gender'],
      fitnessGoal: json['fitnessGoal'],
      activityLevel: json['activityLevel'],
    );
  }
  
  @override
  List<Object?> get props => [
    id, name, email, photoUrl, age, weight, 
    height, gender, fitnessGoal, activityLevel
  ];
}
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, photoUrl, createdAt];
}
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final double weight;
  final double height;
  final int age;
  final double goalWeight;
  final int dailyCalorieTarget;
  final String profileImageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.weight,
    required this.height,
    required this.age,
    required this.goalWeight,
    required this.dailyCalorieTarget,
    required this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
    id, 
    name, 
    email, 
    weight, 
    height, 
    age, 
    goalWeight, 
    dailyCalorieTarget, 
    profileImageUrl
  ];
}
class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? bio;
  final int? age;
  final double? height;
  final double? weight;
  final String? fitnessLevel;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.bio,
    this.age,
    this.height,
    this.weight,
    this.fitnessLevel,
  });
  
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? bio,
    int? age,
    double? height,
    double? weight,
    String? fitnessLevel,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
    );
  }
}
class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final List<String> goals;
  final String fitnessLevel;
  final bool isPremium;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.goals,
    required this.fitnessLevel,
    required this.isPremium,
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
}
