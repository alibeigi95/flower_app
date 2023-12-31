import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../generated/locales.g.dart';
import '../../../shared/flower_progress_indicator.dart';
import '../../../shared/user_type_enum.dart';
import '../../controller/register_page_flower_controller.dart';

class RegisterForm extends GetView<RegisterPageFlowerController> {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Form(
        key: controller.registerFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconUser(),
              _inputFirstName(),
              _inputLastName(),
              _inputEmail(),
              _inputPassword(),
              _inputPasswordConfirm(),
              _inputTypeOfUser(),
              _onSubmitRegisterButton(),
            ],
          ),
        ),
      );

  Widget _iconUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Obx(() => _showImage()),
                  PositionedDirectional(
                    bottom: 9,
                    start: 9,
                    child: Material(
                      color: Colors.lightBlueAccent[100],
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          controller.getImage(imageSource: ImageSource.gallery);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(width: 4, color: Colors.white)),
                          width: 35,
                          height: 35,
                          child: const Icon(Icons.camera_alt,
                              size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Obx(() => _removeImage()),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _showImage() {
    if (controller.imageAddressToShow.isNotEmpty) {
      return Obx(
        () => SizedBox(
          width: 150,
          height: 150,
          child: CircleAvatar(
            backgroundImage: FileImage(
              File(controller.imageAddressToShow.value),
            ),
            radius: 50.0,
          ),
        ),
      );
    }
    return Container(
      alignment: AlignmentDirectional.center,
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: const Color(0xff159947),
        borderRadius: BorderRadius.circular(1000),
      ),
      child: const Icon(
        Icons.person,
        size: 50,
        color: Colors.white,
      ),
    );
  }

  Widget _removeImage() {
    if (controller.imageAddressToShow.isNotEmpty) {
      return PositionedDirectional(
        bottom: 9,
        end: 9,
        child: Material(
          color: Colors.lightBlueAccent[100],
          borderRadius: BorderRadius.circular(100),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              controller.defaultImage();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 4, color: Colors.white)),
              width: 35,
              height: 35,
              child: const Icon(Icons.clear, size: 20, color: Colors.white),
            ),
          ),
        ),
      );
    }
    return const Row();
  }

  Widget _inputFirstName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.firstNameController,
            decoration: InputDecoration(
              icon: const Icon(Icons.person, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  LocaleKeys.register_first_name.tr,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFirstName(value: value!);
            },
          ),
        ),
      ),
    );
  }

  Widget _inputLastName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.lastNameController,
            decoration: InputDecoration(
              icon: const Icon(Icons.person, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  LocaleKeys.register_last_name.tr,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateLastName(value: value!);
            },
          ),
        ),
      ),
    );
  }

  Widget _inputEmail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.emailController,
            decoration: InputDecoration(
              icon: const Icon(Icons.mail, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  LocaleKeys.register_email.tr,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateEmail(value: value!);
            },
          ),
        ),
      ),
    );
  }

  Widget _inputPassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Obx(
            () => TextFormField(
              onChanged: (value) {
                controller.passCheck = value;
              },
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              controller: controller.passwordController,
              obscureText: controller.obscureText.value,
              decoration: InputDecoration(
                  icon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.obscureText.value =
                            !controller.obscureText.value;
                      },
                      icon: Icon(
                        controller.obscureText.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      )),
                  border: InputBorder.none,
                  label: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      LocaleKeys.register_password.tr,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              validator: (value) {
                return controller.validatePassword(value: value!);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputPasswordConfirm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Obx(
            () => TextFormField(
              onChanged: (value) {
                controller.passCheckConfirm = value;
              },
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              controller: controller.passwordConfirmController,
              obscureText: controller.obscureTextConfirm.value,
              decoration: InputDecoration(
                  icon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.obscureTextConfirm.value =
                            !controller.obscureTextConfirm.value;
                      },
                      icon: Icon(
                        controller.obscureTextConfirm.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      )),
                  border: InputBorder.none,
                  label: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      LocaleKeys.register_confirmPassword.tr,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              validator: (value) {
                return controller.validateConfirmPassword(value: value!);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputTypeOfUser() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.green[200], borderRadius: BorderRadius.circular(40)),
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => RadioListTile(
                  title: Text(
                    LocaleKeys.register_vendor.tr,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  value: UserType.vendor,
                  groupValue: controller.selectedUserType.value,
                  onChanged: (userType) {
                    controller.selectedTypeUserValue(userType: userType!);
                  },
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => RadioListTile(
                  title: Text(
                    LocaleKeys.register_customer.tr,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  value: UserType.customer,
                  groupValue: controller.selectedUserType.value,
                  onChanged: (userType) {
                    controller.selectedTypeUserValue(userType: userType!);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _onSubmitRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => _loading()),
    );
  }

  Widget _loading() {
    if (controller.isLoadingRegisterBtn.value) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlowerProgressIndicator(imagePath: 'assets/flower_loading.gif'),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xff159947),
                  borderRadius: BorderRadius.circular(20)),
              height: 45,
              width: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LocaleKeys.register_register_button.tr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              )),
          onTap: () {
            controller.onSubmitRegister();
          },
        ),
      ],
    );
  }
}
