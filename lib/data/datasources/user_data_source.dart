
import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(UserModel user);
}
