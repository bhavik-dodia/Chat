import 'package:flutter/material.dart';

class LoginOption extends StatelessWidget {
  final Function onPressed;

  const LoginOption({Key key, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Existing user?",
          style: TextStyle(
            fontSize: 16,
            color: theme.canvasColor,
          ),
        ),
        SizedBox(height: 16),
        MaterialButton(
          onPressed: onPressed,
          height: 40,
          elevation: 8.0,
          textColor: theme.accentColor,
          color: theme.canvasColor,
          splashColor: Colors.grey.withOpacity(0.2),
          highlightColor: Colors.grey.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
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
