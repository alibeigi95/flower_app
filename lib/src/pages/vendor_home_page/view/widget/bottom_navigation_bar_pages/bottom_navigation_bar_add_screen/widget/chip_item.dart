import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/vendor_home_page_flower_controller.dart';


class ChipItem extends StatelessWidget {
  final int index;


  const ChipItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorHomePageFlowerController>(
      builder: (controller) => Chip(
        backgroundColor: const Color(0xffb6d1ab),
        label: Text(controller.categoryChips[index]),
        deleteIcon: const Icon(Icons.cancel, color: Colors.white),
        onDeleted: () => controller.removeChip( index: index,),
      ),
    );
  }
}