import 'dart:developer';

import 'package:chatapp/main.dart';
import 'package:chatapp/model/chatroom_model.dart';
import 'package:chatapp/model/message_model.dart';
import 'package:chatapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
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
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController textmessagecontroller = TextEditingController();
  void sendmessage() {
    log('on click');
    String msg = textmessagecontroller.text.trim();
    log(msg);
    textmessagecontroller.clear();
    if (msg.isNotEmpty) {
      log('not empty');
      var newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: widget.currentuser.uid,
          createdOn: DateTime.now(),
          text: msg,
          seen: false);
      FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.chatroom.chatroomid)
          .collection('messages')
          .doc(newMessage.messageid)
          .set(newMessage.tomap());
      widget.chatroom.lastmessage = msg;
      FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.tomap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentuser.fullname!),
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
                    .doc(widget.chatroom.chatroomid)
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
                                currentmessage.sender == widget.currentuser.uid
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: currentmessage.sender ==
                                        widget.currentuser.uid
                                    ? const EdgeInsets.only(right: 10, top: 5)
                                    : const EdgeInsets.only(left: 10, top: 5),
                                child: Column(
                                  crossAxisAlignment: currentmessage.sender ==
                                          widget.currentuser.uid
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
                                                  widget.currentuser.uid
                                              ? Colors.blueGrey.withOpacity(.8)
                                              : Colors.blue,
                                        ),
                                        child: Text(
                                          currentmessage.text!,
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
                        sendmessage();
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
