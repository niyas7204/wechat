
import 'package:chatapp/controllers/chatroom_controller.dart';
import 'package:chatapp/model/chatroom_model.dart';
import 'package:chatapp/model/message_model.dart';
import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomPage extends StatelessWidget {
  final Usermodel targetuser;
  final ChatRoomModel chatroom;
  final Usermodel currentuser;
  final User firebaseuser;
  const ChatRoomPage(
      {super.key,
      required this.targetuser,
      required this.chatroom,
      required this.currentuser,
      required this.firebaseuser});

 


  @override
  Widget build(BuildContext context) {
    ChatroomController controller=Get.put(ChatroomController());
     TextEditingController textmessagecontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(currentuser.fullname!),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatroom')
                    .doc(chatroom.chatroomid)
                    .collection('messages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot datasnapshot =
                          snapshot.data as QuerySnapshot;
                      return ListView.builder(
                        reverse: true,
                        itemCount: datasnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentmessage = MessageModel.frommap(
                              datasnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          return Row(
                            mainAxisAlignment:
                                currentmessage.sender == currentuser.uid
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: currentmessage.sender ==
                                        currentuser.uid
                                    ? const EdgeInsets.only(right: 10, top: 5)
                                    : const EdgeInsets.only(left: 10, top: 5),
                                child: Column(
                                  crossAxisAlignment: currentmessage.sender ==
                                          currentuser.uid
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 350),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: currentmessage.sender ==
                                                  currentuser.uid
                                              ? Colors.blueGrey.withOpacity(.8)
                                              : Colors.blue,
                                        ),
                                        child: Text(
                                          currentmessage.message!,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        )),
                                    Text(
                                        "${currentmessage.createdOn!.hour}:${currentmessage.createdOn!.minute}")
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child:
                            Text('an error occured please check your internet'),
                      );
                    } else {
                      return const Center(
                        child: Text('start chating with your friend'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )),
            Container(
              color: Colors.blueGrey.withOpacity(.5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    controller: textmessagecontroller,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'type..',
                    ),
                  )),
                  IconButton(
                      onPressed: () {
                        
                      },
                      icon: const Icon(Icons.send)),
                  IconButton(
                      onPressed: () {
                        controller.sendMessage(textmessagecontroller.text, currentuser.uid!, MessageType.text, chatroom.chatroomid!);
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
