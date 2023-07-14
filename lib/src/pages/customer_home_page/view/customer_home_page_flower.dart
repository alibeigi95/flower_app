import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/customer_home_page_flower_controller.dart';

class CustomerHomePageFlower extends GetView<CustomerHomePageFlowerController> {
  const CustomerHomePageFlower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Row(
                children: [
                  const Text('Refresh'),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      // controller.refresh();
                    },
                  ),
                ],
              ),
            ],
            title: const Text('Customer Home page flower'),
            backgroundColor: const Color(0xff04927c)),
        body: Obx(() => CustomerHomePageFlowerController.widgetOptions
            .elementAt(controller.selectedIndex.value)),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.white,
            backgroundColor: const Color(0xff8ab178),
            currentIndex: controller.selectedIndex.value,
            onTap: (value) {
              controller.onItemTapped(value);
            },
            items:  <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
            BottomNavigationBarItem(
              icon: Stack(
                  children: [
                  Icon(Icons.shopping_cart),
              Obx(() {
                int cartCount = controller.cartCount.value;
                if (cartCount == 0) {
                  return SizedBox.shrink();
                } else {
                  return Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              }),
            ]),
            label: 'Cart',
          ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
}
