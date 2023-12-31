import 'bought_flowers_view_model.dart';
import 'user_view_model.dart';

class AddCartOrderDto {
  final UserViewModel user;
  final String dateTime;
  int totalPrice;
  final List<BoughtFlowersViewModel> boughtFlowers;

  AddCartOrderDto({
    required this.user,
    required this.dateTime,
    required this.totalPrice,
    required this.boughtFlowers,
  });


  Map<String, dynamic> toJson() {


    return {
      'user': user.toJson(),
      'dateTime': dateTime,
      'totalPrice': totalPrice,
      'boughtFlowers':  boughtFlowers.map((e) => e.toJson()).toList(),
    };
  }

}
