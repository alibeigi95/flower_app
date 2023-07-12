import '../../shared/user_type_enum.dart';

class RegisterVendorDto {
  final UserType userType;
  final String firstName, lastName, email, passWord, image;

  RegisterVendorDto({
    required this.userType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.passWord,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
        'userType': userType.value,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'passWord': passWord,
        'image': image,
        'flowerList': []
      };
}
