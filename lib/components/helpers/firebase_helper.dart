import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<Usermodel?> getUserbyId(String uid) async {
    Usermodel? usermodel;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (docsnap.data() != null) {
      usermodel = Usermodel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return usermodel;
  }
}
