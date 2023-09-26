import 'package:chatapp/components/common/text_fields.dart';
import 'package:chatapp/components/common/text_widgets.dart';
import 'package:chatapp/components/constants/sized.dart';
import 'package:chatapp/components/logo.dart';
import 'package:chatapp/controllers/login_page_controller.dart';
import 'package:chatapp/view/pages/signup_page.dart';
import 'package:chatapp/view/widgets/alert_diologes/alerts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LogInPageController controller = Get.put(LogInPageController());
     final AlertdiologeWidgets alertdcontroller=Get.put(AlertdiologeWidgets());
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
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
                Textwidgets.captionHead('Log In'),
                Sized.height10,
                TextFieldWidgets.textFieldWithLabel('Email', emailController),
                Sized.height10,
                TextFieldWidgets.textFieldWithLabel(
                    'Password', passwordController),
                    Obx(() {
                      if(Get.find<LogInPageController>().isloading.value){
return const CircularProgressIndicator();
                      }
                      else{
                        return const SizedBox();
                      }
                    }),
                SizedBox(
                  height: 30,
                  width: 234,
                  child: Row(
                    children: [
                      const Text('Dont have an account ?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ));
                          },
                          child: const Text(
                            'Create New',
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                ),
                 
                ElevatedButton(
                    onPressed: () {
                      controller.chekvalues(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());
                    },
                    child: const Text('Log In'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
