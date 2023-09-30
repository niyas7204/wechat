
import 'dart:io';

import 'package:chatapp/main.dart';
import 'package:chatapp/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatroomController extends GetxController{
  Future<void> pickImage()async{
final picker=ImagePicker();
final imageFile=await picker.pickImage(source: ImageSource.gallery);
if(imageFile!=null){

}
  }
  Future uploadImage(XFile imageFile)async{
    String fileName=Uuid().v1();
    var ref=FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
    var uploadTask=await ref.putFile(File(imageFile.path));
 String imageUrl=await uploadTask.ref.getDownloadURL();
 return imageUrl;
  }
  sendMessage(String message,String sender,MessageType messageType,String chatroomId){
MessageModel newMessage=MessageModel(
  messageid:uuid.v1(),
  sender: sender,
  message: message,
  messageType: messageType,
  seen: false,
  createdOn: DateTime.now(),

);
FirebaseFirestore.instance.collection('chatroom').doc(chatroomId).collection('messages').doc(newMessage.messageid).set(newMessage.tomap());

  }
}