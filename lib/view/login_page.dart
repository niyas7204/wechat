import 'dart:developer';

import 'package:chatapp/components/common/text_fields.dart';
import 'package:chatapp/components/common/text_widgets.dart';
import 'package:chatapp/components/constants/sized.dart';
import 'package:chatapp/components/logo.dart';
import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/view/home.dart';
import 'package:chatapp/view/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  chekvalues() {
    String email = emailController.text.trim();

    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      log('fields must fill');
    } else {
      log('signed');
      login(email, password);
    }
  }

  login(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log('erroor $e');
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      Usermodel usermodel =
          Usermodel.fromMap(userData.data() as Map<String, dynamic>);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            HomeScreem(usermodel: usermodel, firebaseuser: credential!.user!),
      ));
    }
  }

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
                ElevatedButton(
                    onPressed: () {
                      chekvalues();
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
