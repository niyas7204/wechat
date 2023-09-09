import 'package:chatapp/components/common/text_fields.dart';
import 'package:chatapp/components/common/text_widgets.dart';
import 'package:chatapp/components/constants/sized.dart';
import 'package:chatapp/components/logo.dart';
import 'package:chatapp/view/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                ElevatedButton(onPressed: () {}, child: const Text('Log In'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
