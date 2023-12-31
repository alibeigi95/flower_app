import 'package:flower_app/src/pages/login_page/view/widget/login_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../controller/login_page_flower_controller.dart';

class LoginFormPage extends GetView<LoginPageFlowerController> {
   const LoginFormPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => Scaffold(
    key: controller.scaffoldKey,
    appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            controller.scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title:  Text(LocaleKeys.login_title.tr),
        backgroundColor: const Color(0xff04927c)),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff04927c),
            ),
            child: Text(
              'Flower Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('English'),
            onTap: () {
              Get.updateLocale(const Locale('en', 'US'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('فارسی'),
            onTap: () {
              Get.updateLocale(const Locale('fa', 'IR'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title:  Text(LocaleKeys.vendor_page_about.tr),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
        body: const LoginForm(),
      );
}
