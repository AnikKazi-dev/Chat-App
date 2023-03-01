import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy(
            "createdAt",
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return MessageBubble(
              snapshot.data!.docs[index]["text"],
              snapshot.data!.docs[index]["username"],
              snapshot.data!.docs[index]["userImage"],
              snapshot.data!.docs[index]["userId"] ==
                  FirebaseAuth.instance.currentUser?.uid,
              key: ValueKey(snapshot.data?.docs[index].id),
            );
          },
        );
      },
    );
  }
}
