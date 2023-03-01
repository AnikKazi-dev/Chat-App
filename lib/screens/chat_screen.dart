import 'package:chat_app/widgets/messages.dart';
import 'package:chat_app/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    //final fbm = FirebaseMessaging.instance.onTokenRefresh;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("................Hello............");
      print("....................${message.data}................");
      if (message.notification != null) {
        print(".......No.........Hello............");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Group Chat"),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8, top: 2),
              child: DropdownButton(
                underline: Container(),
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8),
                          Text("Logout"),
                        ],
                      ),
                    ),
                    value: "logout",
                  ),
                ],
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == "logout") {
                    FirebaseAuth.instance.signOut();
                  }
                },
              ),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Messages(),
              ),
              NewMessages(),
            ],
          ),
        ),
      ),
    );
  }
}
