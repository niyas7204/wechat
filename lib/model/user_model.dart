class Usermodel {
  String? uid;
  String? fullname;
  String? email;
  Usermodel({this.uid, this.fullname, this.email});
  Usermodel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    fullname = map['fullname'];
    email = map['email'];
  }
  Map<String, dynamic> tomap() {
    return {'uid': uid, 'fullname': fullname, 'email': email};
  }
}
