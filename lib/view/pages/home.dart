import 'dart:developer';

import 'package:chatapp/components/helpers/firebase_helper.dart';
import 'package:chatapp/model/chatroom_model.dart';
import 'package:chatapp/model/user_model.dart';
import 'package:chatapp/view/pages/chatroom.dart';
import 'package:chatapp/view/pages/login_page.dart';
import 'package:chatapp/view/pages/search_page.dart';
import 'package:chatapp/view/widgets/alert_diologes/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreem extends StatefulWidget {

  final Usermodel usermodel;
  final User firebaseuser;
  const HomeScreem(
      {super.key, required this.usermodel, required this.firebaseuser});

  @override
  State<HomeScreem> createState() => _HomeScreemState();
}

class _HomeScreemState extends State<HomeScreem> {
  @override
  Widget build(BuildContext context) {
    final AlertdiologeWidgets alertdcontroller=Get.put(AlertdiologeWidgets());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              return alertdcontroller.loadingAlert(context);
            },
            icon: Icon(Icons.add)),
        actions: [
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
            child: const Row(
              children: [Text('Log out'), Icon(Icons.exit_to_app)],
            ),
          )
        ],
        title: const Text('weChat'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchPage(
                usermodel: widget.usermodel, firebaseuser: widget.firebaseuser),
          ));
        },
      ),
      body: SafeArea(
          child: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chatroom')
              .where('participants.${widget.usermodel.uid}', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            log(snapshot.connectionState.toString());
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot asnap = snapshot.data as QuerySnapshot;

                return ListView.builder(
                  itemCount: asnap.docs.length,
                  itemBuilder: (context, index) {
                    ChatRoomModel chatroomdata = ChatRoomModel.fromMap(
                        asnap.docs[index].data() as Map<String, dynamic>);
                    Map<String, dynamic> participants =
                        chatroomdata.participants!;
                    List<String> participantkey = participants.keys.toList();
                    participantkey.remove(widget.usermodel.uid);
                    return FutureBuilder(
                      future: FirebaseHelper.getUserbyId(participantkey[0]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data != null) {
                            Usermodel targetuser = snapshot.data as Usermodel;
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatRoomPage(
                                    targetuser: targetuser,
                                    currentuser: widget.usermodel,
                                    firebaseuser: widget.firebaseuser,
                                    chatroom: chatroomdata,
                                  ),
                                ));
                              },
                              leading: const CircleAvatar(),
                              title: Text(targetuser.fullname!),
                            );
                          } else {
                            return Center(
                                child:
                                    alertdcontroller.loadingAlert(context));
                          }
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('error'),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: Text('no chat found'),
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
    );
  }
}
