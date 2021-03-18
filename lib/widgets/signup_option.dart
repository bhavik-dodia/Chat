import 'package:flutter/material.dart';

class SignUpOption extends StatelessWidget {
  final Function onPressed;

  const SignUpOption({Key key, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "OR",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: 24),
        MaterialButton(
          onPressed: onPressed,
          height: 40,
          elevation: 8.0,
          textColor: theme.canvasColor,
          color: theme.accentColor,
          splashColor: Colors.blueAccent[100],
          highlightColor: Colors.blueAccent[100].withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
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
