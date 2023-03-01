import 'dart:io';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthenticationForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext context,
    File? image,
  ) submitFunction;
  final bool isLoading;

  AuthenticationForm(this.submitFunction, this.isLoading);

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = "";
  var _userUsername = "";
  var _userPass = "";
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final _isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick an image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      return;
    }

    if (_isValid!) {
      _formKey.currentState!.save();
      widget.submitFunction(
        _userEmail.trim(),
        _userPass.trim(),
        _userUsername.trim(),
        _isLogin,
        context,
        _userImageFile,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white70,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey("email"),
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email address"),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      onSaved: (newValue) {
                        _userUsername = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                  TextFormField(
                    onSaved: (newValue) {
                      _userPass = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? "Login" : "Signup"),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      key: ValueKey("password"),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? "Create new account"
                            : "I already have an account",
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
