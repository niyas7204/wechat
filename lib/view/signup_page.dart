import 'dart:developer';

import 'package:chatapp/components/common/text_fields.dart';
import 'package:chatapp/components/common/text_widgets.dart';
import 'package:chatapp/components/constants/sized.dart';
import 'package:chatapp/components/logo.dart';
import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/view/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  chekvalues() {
    String email = emailController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmpasswordController.text.trim();
    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      log('fields must fill');
    } else if (password != confirmpassword) {
      log('passwords not match');
    } else {
      log('signed');
      signup(email, username, password);
    }
  }

  signup(String email, String username, String password) async {
    UserCredential? credential;
    try {
      log('try');
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      log('try c');
    } on FirebaseAuthException catch (e) {
      log('ex');
      log('error ${e.message}');
    }
    log('hh');
    if (credential != null) {
      String uid = credential.user!.uid;
      Usermodel userData = Usermodel(
        uid: uid,
        email: email,
        fullname: username,
      );
      log('login');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData.tomap())
          .then((value) =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreem(
                    usermodel: userData, firebaseuser: credential!.user!),
              )));
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
                      chekvalues();
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
