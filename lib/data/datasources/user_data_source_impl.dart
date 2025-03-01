
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'user_data_source.dart';

class UserDataSourceImpl implements UserDataSource {
  final SharedPreferences sharedPreferences;

  UserDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getUserProfile() async {
    // In a real app, this would fetch from an API
    // For now, we'll return a mock user or fetch from local storage
    final userData = sharedPreferences.getString('user_data');
    
    if (userData != null) {
      return UserModel.fromJson(json.decode(userData));
    } else {
      // Return mock user data
      return UserModel(
        id: '1',
        name: 'Alex Johnson',
        email: 'alex@example.com',
        weight: 70,
        height: 175,
        age: 28,
        goalWeight: 65,
        dailyCalorieTarget: 2000,
        profileImageUrl: 'assets/images/profile_placeholder.png'
      );
    }
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    // In a real app, this would update the user on an API
    // For now, we'll just save to local storage
    await sharedPreferences.setString('user_data', json.encode(user.toJson()));
    return user;
  }
}
