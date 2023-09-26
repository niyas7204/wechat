import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/view/pages/home.dart';
import 'package:chatapp/view/widgets/alert_diologes/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';

class SignUpPageController extends GetxController {
  RxBool isloading=false.obs;
  final AlertdiologeWidgets alertdcontroller=Get.put(AlertdiologeWidgets());
  chekvalues(
      {required String email,
      required String username,
      required String password,
      required String confirmpassword}) {
        Get.find<SignUpPageController>().isloading.value=true;
    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
           Get.find<SignUpPageController>().isloading.value=false;
      alertdcontroller.warnigAlert('All fields should be complete.');
    } else if (password != confirmpassword) {
      alertdcontroller.warnigAlert('passwords not match');
    } else {
      signup(email, username, password);
    }
  }

  signup(String email, String username, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
           
      String uid = credential.user!.uid;
      Usermodel userData = Usermodel(
        uid: uid,
        email: email,
        fullname: username,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData.tomap())
          .then((value) {
        Get.to(
          () =>
              HomeScreem(usermodel: userData, firebaseuser: credential!.user!),
        );
      });
    
    } on FirebaseAuthException catch (error) {
      alertdcontroller.warnigAlert('${error.message}');
    }finally{
       Get.find<SignUpPageController>().isloading.value=false;
    }

   
  }
}
