import 'package:flower_app/src/pages/vendor_home_page/view/widget/vendor_bought_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_home_page_flower_controller.dart';

class HistoryScreen extends GetView<VendorHomePageFlowerController> {
   HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: RefreshIndicator(
        onRefresh: controller.getFlowerList,
        child:const VendorBoughtList(),
      ),

    );
  }


}
