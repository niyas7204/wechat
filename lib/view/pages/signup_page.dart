import 'package:chatapp/components/common/text_fields.dart';
import 'package:chatapp/components/common/text_widgets.dart';
import 'package:chatapp/components/constants/sized.dart';
import 'package:chatapp/components/logo.dart';
import 'package:chatapp/controllers/signup_page_controllers.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmpasswordController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    final SignUpPageController controller = Get.put(SignUpPageController());
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                logo(),
                Sized.height10,
                Textwidgets.captionHead('Sign Up'),
                Sized.height10,
                TextFieldWidgets.textFieldWithLabel(
                    'User Name', usernameController),
                Sized.height10,
                TextFieldWidgets.textFieldWithLabel('Email', emailController),
                Sized.height10,
                TextFieldWidgets.textFieldWithLabel(
                    'Password', passwordController),
                Sized.height10,
                TextFieldWidgets.textFieldWithLabel(
                    'Confirm Password', confirmpasswordController),
                ElevatedButton(
                    onPressed: () {
                      controller.chekvalues(
                          email: emailController.text.trim(),
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                          confirmpassword:
                              confirmpasswordController.text.trim());
                    },
                    child: const Text('Sign Up'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
