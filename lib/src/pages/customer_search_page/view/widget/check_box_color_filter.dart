import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../shared/grid_item.dart';
import '../../controller/customer_search_page_controller.dart';

class CheckBoxColorFilter extends GetView<CustomerSearchPageController> {
  const CheckBoxColorFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerSearchPageController>(
      builder: (_) => Obx(
        () => GridView.builder(
          shrinkWrap: true,
          itemCount: controller.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            GridItem item = controller.items[index];
            return InkWell(
              onTap: () {
                controller.colorToggleSelection(colorIndex: index);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: item.color,
                ),
                child: item.isSelected
                    ? Align(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
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