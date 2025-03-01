
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    required String email,
    required double weight,
    required double height,
    required int age,
    required double goalWeight,
    required int dailyCalorieTarget,
    required String profileImageUrl,
  }) : super(
    id: id,
    name: name,
    email: email,
    weight: weight,
    height: height,
    age: age,
    goalWeight: goalWeight,
    dailyCalorieTarget: dailyCalorieTarget,
    profileImageUrl: profileImageUrl,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      weight: json['weight'].toDouble(),
      height: json['height'].toDouble(),
      age: json['age'],
      goalWeight: json['goalWeight'].toDouble(),
      dailyCalorieTarget: json['dailyCalorieTarget'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'weight': weight,
      'height': height,
      'age': age,
      'goalWeight': goalWeight,
      'dailyCalorieTarget': dailyCalorieTarget,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      weight: user.weight,
      height: user.height,
      age: user.age,
      goalWeight: user.goalWeight,
      dailyCalorieTarget: user.dailyCalorieTarget,
      profileImageUrl: user.profileImageUrl,
    );
  }
}
