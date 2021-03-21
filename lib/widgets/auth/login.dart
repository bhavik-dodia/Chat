import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailRegex =
      RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
  final _passRegex = RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&-+=()])(?=\S+$).{8,}$');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordNode = FocusNode();
  bool ot = true, _isLoading = false;
  String _userEmail = '', _userPassword = '';

  @override
  void dispose() {
    _passwordNode.dispose();
    super.dispose();
  }

  void _trySubmit() async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();
      try {
        setState(() => _isLoading = true);
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _userEmail,
              password: _userPassword,
            )
            .whenComplete(
              () => setState(() => _isLoading = false),
            );
      } on FirebaseAuthException catch (e) {
        var message = 'An error occurred, please check your credentials!';
        if (e.message != null) message = e.message;
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
      } catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Welcome to",
          style: TextStyle(
            fontSize: 16,
            color: theme.canvasColor,
            height: 2,
          ),
        ),
        Text(
          "CHAT",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: theme.canvasColor,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        Text(
          "Please login to continue",
          style: TextStyle(
            fontSize: 16,
            color: theme.canvasColor,
            height: 1,
          ),
        ),
        SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: theme.cardColor.withOpacity(0.8),
                  ),
                  hintText: 'Email Id',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: theme.cardColor.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                  errorStyle: TextStyle(
                    color: Colors.deepOrangeAccent,
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
                  fillColor: Colors.blueAccent[100],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                cursorColor: theme.accentColor,
                style: TextStyle(
                  color: theme.cardColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
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
                  color: theme.cardColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: theme.cardColor.withOpacity(0.8),
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: theme.cardColor.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                  errorStyle: TextStyle(
                    color: Colors.deepOrangeAccent,
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
                  fillColor: Colors.blueAccent[100],
                  contentPadding: const EdgeInsets.only(left: 16, right: 0),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => ot = !ot),
                    tooltip: ot ? 'show password' : 'hide password',
                    icon: Icon(
                      ot
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: theme.cardColor.withOpacity(0.8),
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
                    return 'Enter a strong password';
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
          textColor: Colors.blueAccent,
          color: theme.canvasColor,
          splashColor: Colors.grey.withOpacity(0.2),
          highlightColor: Colors.grey.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(12.5),
                  child: LinearProgressIndicator(),
                )
              : Text(
                  "LOGIN",
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
