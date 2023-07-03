
import '../../shared/user_type_enum.dart';

class UserViewModel {
  final int id;
  final UserType userType;
  final String firstName, lastName, email, passWord, image;

  UserViewModel({
    required this.id,
    required this.userType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.passWord,
    required this.image,
  });

  factory UserViewModel.fromJson(Map<String, dynamic> json) {
    return UserViewModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      passWord: json['passWord'],
      image: json['image'],
      userType: UserType.getUserTypeFromValue(json['userType']),
    );
  }
}
