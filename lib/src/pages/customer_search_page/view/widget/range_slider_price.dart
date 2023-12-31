import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/customer_search_page_controller.dart';

class CustomerRangeSliderPrice1 extends GetView<CustomerSearchPageController> {
  const CustomerRangeSliderPrice1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RangeSlider(
        values: controller.values,
        min: 0,
        max: controller.maxPrice,
        onChanged: (values) {
          controller.setRangeValues(rangeValues: values);
        },
        labels: RangeLabels(
          '\$${controller.values.start.toInt()}',
          '\$${controller.values.end.toInt()}',
        ),
        divisions: 100,
      ),
    );
  }
}
