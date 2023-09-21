import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/view/pages/home.dart';
import 'package:chatapp/view/widgets/alert_diologes/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LogInPageController extends GetxController {
  chekvalues({required String email, required String password}) {
    if (email.isEmpty || password.isEmpty) {
      AlertdiologeWidgets.warnigAlert('fields must fill');
    } else {
      login(email, password);
    }
  }

  login(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      AlertdiologeWidgets.warnigAlert(e.message!);
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      Usermodel usermodel =
          Usermodel.fromMap(userData.data() as Map<String, dynamic>);
      Get.to(() =>
          HomeScreem(usermodel: usermodel, firebaseuser: credential!.user!));
     
    }
  }
}
