import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'input_image.dart';

class SignUp extends StatefulWidget {
  final Function goToLogin;

  const SignUp({Key key, this.goToLogin}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailRegex =
      RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
  final _passRegex = RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&-+=()])(?=\S+$).{8,}$');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  bool ot = true, _isLoading = false;
  String _userEmail = '', _userName = '', _userPassword = '';
  File _pickedImage;

  void _selectImage(File pickedImage) => _pickedImage = pickedImage;

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  void _trySubmit() async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();

      if (_pickedImage == null) {
        _showSnackBar('Please select an image');
        return;
      }

      _formKey.currentState.save();
      FirebaseApp tempApp;
      try {
        tempApp = await Firebase.initializeApp(
          name: 'tempApp',
          options: Firebase.app().options,
        );
        setState(() => _isLoading = true);
        final authResult = await FirebaseAuth.instanceFor(app: tempApp)
            .createUserWithEmailAndPassword(
              email: _userEmail,
              password: _userPassword,
            )
            .whenComplete(
              () => setState(() => _isLoading = false),
            );
        widget.goToLogin();
        final ref = FirebaseStorage.instanceFor(app: tempApp)
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(_pickedImage);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instanceFor(app: tempApp)
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'id': authResult.user.uid,
          'name': _userName,
          'email': _userEmail,
          'imageUrl': url,
        });
      } on FirebaseAuthException catch (e) {
        var message = 'An error occurred, please check your credentials!';
        if (e.message != null) message = e.message;
        _showSnackBar(message);
        await tempApp?.delete();
      } catch (e) {
        print(e.message);
        await tempApp?.delete();
      } finally {
        await tempApp?.delete();
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 8.0,
        margin: const EdgeInsets.all(8.0),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).cardColor,
        duration: const Duration(seconds: 3),
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Sign up with",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
            height: 2,
          ),
        ),
        Text(
          "CHAT",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        InputImage(onSelectImage: _selectImage),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                cursorColor: theme.accentColor,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.blueAccent[100],
                  ),
                  hintText: 'Name',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent[100],
                    fontWeight: FontWeight.bold,
                  ),
                  errorStyle: TextStyle(
                    // color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.2),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a name';
                  return null;
                },
                onSaved: (value) => _userName = value.trim(),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailNode),
              ),
              SizedBox(height: 16),
              TextFormField(
                cursorColor: theme.accentColor,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.blueAccent[100],
                  ),
                  hintText: 'Email Id',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent[100],
                    fontWeight: FontWeight.bold,
                  ),
                  errorStyle: TextStyle(
                    // color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.2),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                focusNode: _emailNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.isEmpty) return 'Please enter an email id';
                  if (!_emailRegex.hasMatch(value))
                    return 'Please enter valid email id';
                  return null;
                },
                onSaved: (value) => _userEmail = value.trim(),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passwordNode),
              ),
              SizedBox(height: 16),
              TextFormField(
                obscureText: ot,
                cursorColor: theme.accentColor,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.blueAccent[100],
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent[100],
                    fontWeight: FontWeight.bold,
                  ),
                  errorStyle: TextStyle(
                    // color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.2),
                  contentPadding: const EdgeInsets.only(left: 16, right: 0),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => ot = !ot),
                    tooltip: ot ? 'show password' : 'hide password',
                    icon: Icon(
                      ot
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.blueAccent[100],
                    ),
                  ),
                ),
                focusNode: _passwordNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a password';
                  // else if (value == 'Abc@1234')
                  //   return 'Demo password can\'t be used';
                  if (!_passRegex.hasMatch(value))
                    return 'Please enter a strong password';
                  return null;
                },
                onSaved: (value) => _userPassword = value.trim(),
                onFieldSubmitted: (_) => _trySubmit(),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        MaterialButton(
          onPressed: _isLoading ? null : _trySubmit,
          height: 40,
          elevation: 8.0,
          textColor: theme.canvasColor,
          color: theme.accentColor,
          splashColor: Colors.blueAccent[100],
          highlightColor: Colors.blueAccent[100].withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(12.5),
                  child: LinearProgressIndicator(),
                )
              : Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
