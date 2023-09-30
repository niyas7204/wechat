import 'dart:developer';

import 'package:chatapp/main.dart';
import 'package:chatapp/model/chatroom_model.dart';
import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/view/pages/chatroom.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final Usermodel usermodel;
  final User firebaseuser;
  const SearchPage(
      {super.key, required this.usermodel, required this.firebaseuser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController emailcontroller = TextEditingController();
  Future<ChatRoomModel?> getchatroom(Usermodel trargetedUser) async {
    ChatRoomModel? chatroom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatroom')
        .where('participants.${widget.firebaseuser.uid}', isEqualTo: true)
        .where('participants.${trargetedUser.uid}', isEqualTo: true)
        .get();

    if (snapshot.docs.isEmpty) {
      log('chatroom not exist');
      ChatRoomModel newchatroom =
          ChatRoomModel(chatroomid: uuid.v1(), lastmessage: '', participants: {
        widget.usermodel.uid!: true,
        trargetedUser.uid!: true,
      });
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(newchatroom.chatroomid)
          .set(newchatroom.tomap());
    } else {
      log('chat room exist');
      var docdata = snapshot.docs[0].data();
      ChatRoomModel existingchatrom =
          ChatRoomModel.fromMap(docdata as Map<String, dynamic>);
      chatroom = existingchatrom;
    }
    return chatroom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('search'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text('search')),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: emailcontroller.text)
                .where('email', isNotEqualTo: widget.usermodel.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                    Map<String, dynamic> usermap =
                        datasnapshot.docs[0].data() as Map<String, dynamic>;
                    Usermodel searcheduser = Usermodel.fromMap(usermap);
                    return ListTile(
                      onTap: () async {
                        ChatRoomModel? chatroom =
                            await getchatroom(searcheduser);
                        if (chatroom != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatRoomPage(
                              targetuser: searcheduser,
                              currentuser: widget.usermodel,
                              firebaseuser: widget.firebaseuser,
                              chatroom: chatroom,
                            ),
                          ));
                        }
                      },
                      leading: const CircleAvatar(),
                      title: Text(searcheduser.fullname!),
                    );
                  } else {
                    return const Center(
                      child: Text('No user found'),
                    );
                  }
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('an error occured'),
                  );
                } else {
                  return const Center(
                    child: Text('No user found'),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      )),
    );
  }
}
