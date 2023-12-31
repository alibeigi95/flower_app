import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/grid_item.dart';
import '../../controller/vendor_search_page_controller.dart';


class CheckBoxColorFilter extends GetView<VendorSearchPageController> {
  const CheckBoxColorFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorSearchPageController>(
      builder: (_) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Obx(
          () => GridView.builder(
            shrinkWrap: true,
            itemCount: controller.colorItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              ColorGridItem item = controller.colorItems[index];
              return InkWell(
                onTap: () {
                  controller.colorToggleSelection( colorToggleIndex: index);
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
      ),
    );
  }
}
