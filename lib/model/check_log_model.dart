import 'package:chatapp/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckUserModel {
  User? firebaseuser;
  Usermodel? userData;
  bool? islogged;
  CheckUserModel({this.firebaseuser, this.userData, this.islogged});
}
