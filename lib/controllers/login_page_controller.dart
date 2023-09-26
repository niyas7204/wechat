import 'dart:developer';

import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/view/pages/home.dart';
import 'package:chatapp/view/widgets/alert_diologes/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LogInPageController extends GetxController {
  RxBool isloading=false.obs;
   final AlertdiologeWidgets alertdcontroller=Get.put(AlertdiologeWidgets());
  chekvalues({required String email, required String password}) {
    Get.find<LogInPageController>().isloading.value=true;
    log('check');
    if (email.isEmpty || password.isEmpty) {
      Get.find<LogInPageController>().isloading.value=false;
      log('empty');
      alertdcontroller.warnigAlert('fields must fill');
    } else {
      log('login');

      login(email, password);
    }
  }

  login(String email, String password) async {
    UserCredential? credential;
    try {
      log('try');
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
          log('crd');
          String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      Usermodel usermodel =
          Usermodel.fromMap(userData.data() as Map<String, dynamic>);
      Get.to(() =>
          HomeScreem(usermodel: usermodel, firebaseuser: credential!.user!));
    } on FirebaseAuthException catch (e) {
      log('error$e');
      alertdcontroller.warnigAlert(e.message!);
    }
    finally{
      Get.find<LogInPageController>().isloading.value=false;
    }
  }
}
