import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> createUserAccount({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> updateUser({required UpdateUserAction action, required dynamic userData});

  Future<void> deleteAccount({
    required String email,
  });
}
