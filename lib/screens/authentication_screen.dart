import 'dart:io';

import 'package:chat_app/widgets/authentication_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthenticationForm(String email, String password, String username,
      bool isLogin, BuildContext context,
      [File? image = null]) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(authResult.user!.uid + ".jpg");

        await ref.putFile(image!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user!.uid)
            .set({
          "username": username,
          "email": email,
          "image_url": url,
        });
      }
    } on PlatformException catch (error) {
      // var message = "An error occurred, please check your credentials";

      // if (error.message != null) {
      //   message = error.message.toString();
      // }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      print(error.toString());
      setState(() {
        _isLoading = false;
      });
    }
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
        body: AuthenticationForm(_submitAuthenticationForm, _isLoading),
      ),
    );
  }
}
