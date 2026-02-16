import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
  });

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
    );
  }
}
