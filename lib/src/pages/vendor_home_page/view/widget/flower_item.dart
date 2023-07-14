import 'dart:typed_data';
import 'package:flower_app/src/pages/vendor_home_page/view/widget/string_to_image_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_home_page_flower_controller.dart';
import '../../models/flower_list_view_model.dart';
import 'dart:convert';
import 'delete_alert_dialog.dart';

class FlowerItem extends GetView<VendorHomePageFlowerController> {
  final FlowerListViewModel flowerItem;

  const FlowerItem({
    required this.flowerItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {
              controller.goToEditFlowerPage(flowerItem);
            },
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xff9ae4ec),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    constraints: const BoxConstraints.expand(
                      height: 200,
                    ),
                    child: StringToImagePost(base64String: flowerItem.image),
                  ),
                  Row(
                    children: [
                      const Text('Flower Name : '),
                      Text(flowerItem.name),
                    ],
                  ),
                  const Row(
                    children: [
                      Text('Flower Description '),
                    ],
                  ),
                  Row(
                    children: [
                      Text(flowerItem.shortDescription),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Flower Color :'),
                      Container(
                        height: 20,
                        width: 20,
                        color: Color(flowerItem.color),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Flower Price :'),
                      Text(flowerItem.price.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              controller.editCountFlowerMinus(flowerItem);
                            },
                          ),
                          Text('Count Flower: ${flowerItem.countInStock}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              controller.editCountFlowerPlus(flowerItem);
                            },
                          ),
                          DeleteAlertDialog(flowerItem: flowerItem),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _flowerChip(),
                    ],
                  ),
                ],
              ),
            )),
      );

  Widget _flowerChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            width: 300,
            child: Column(
              children: [
                Expanded(
                  child: GetBuilder<VendorHomePageFlowerController>(
                    builder: (controller) => ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: flowerItem.category.length,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ChipWithDeleteIcon(
                          index,
                          flowerItem: flowerItem,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChipWithDeleteIcon extends StatelessWidget {
  final int index;
  final FlowerListViewModel flowerItem;

  const ChipWithDeleteIcon(this.index, {super.key, required this.flowerItem});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorHomePageFlowerController>(
      builder: (controller) => Chip(
        backgroundColor: const Color(0xffb6d1ab),
        label: Text(flowerItem.category[index]),
        deleteIcon: const Icon(Icons.cancel, color: Colors.white),
        /*onDeleted: () => controller.removeChip(index),*/
      ),
    );
  }
}
