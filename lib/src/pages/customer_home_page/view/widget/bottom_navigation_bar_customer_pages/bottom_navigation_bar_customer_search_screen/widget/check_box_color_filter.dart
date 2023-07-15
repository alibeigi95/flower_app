import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../../shared/grid_item.dart';
import '../../../../../controller/customer_home_page_flower_controller.dart';

class CheckBoxColorFilter extends GetView<CustomerHomePageFlowerController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerHomePageFlowerController>(
      builder: (_) => Obx(
        () => GridView.builder(
          shrinkWrap: true,
          itemCount: controller.items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            GridItem item = controller.items[index];
            return InkWell(
              onTap: () {
                controller.toggleSelection(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: item.color,
                ),
                child: item.isSelected
                    ? Align(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 20,
                            color: item.color,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
