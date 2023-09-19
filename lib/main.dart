import 'dart:developer';

import 'package:chatapp/model/check_log_model.dart';
import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/view/home.dart';
import 'package:chatapp/view/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<CheckUserModel>(
          future: checkLog(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.islogged!) {
                log('loged');
                return HomeScreem(
                    usermodel: snapshot.data!.userData!,
                    firebaseuser: snapshot.data!.firebaseuser!);
              } else {
                return const LoginPage();
              }
            } else {
              return const LoginPage();
            }
          },
        ));
  }
}

Future<CheckUserModel> checkLog() async {
  CheckUserModel? checkUser;
  Usermodel? usermodel;
  User? currentuser = FirebaseAuth.instance.currentUser;
  if (currentuser != null) {
    DocumentSnapshot docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentuser.uid)
        .get();
    usermodel = Usermodel.fromMap(docs.data() as Map<String, dynamic>);
    checkUser = CheckUserModel(
      firebaseuser: currentuser,
      userData: usermodel,
      islogged: true,
    );
  } else {
    checkUser = CheckUserModel(
      firebaseuser: currentuser,
      userData: usermodel,
      islogged: false,
    );
  }
  return checkUser;
}
