import 'package:flutter/material.dart';

import '../helpers/curved_painter.dart';
import '../widgets/login.dart';
import '../widgets/login_option.dart';
import '../widgets/signup.dart';
import '../widgets/signup_option.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool login = true;
  final duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: isPortrait ? Axis.vertical : Axis.horizontal,
        child: isPortrait
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => setState(() => login = true),
                    child: AnimatedContainer(
                      duration: duration,
                      curve: Curves.ease,
                      height: login
                          ? mediaQuery.size.height * 0.6
                          : mediaQuery.size.height * 0.4,
                      child: CustomPaint(
                        painter: CurvePainter(login, isPortrait),
                        child: Container(
                          padding: EdgeInsets.only(bottom: login ? 0 : 50),
                          child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                child: login
                                    ? Login()
                                    : LoginOption(
                                        onPressed: () =>
                                            setState(() => login = true),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => login = false),
                    child: AnimatedContainer(
                      duration: duration,
                      curve: Curves.ease,
                      height: login
                          ? mediaQuery.size.height * 0.4
                          : mediaQuery.size.height * 0.6,
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(top: login ? 50 : 0),
                        child: Center(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              child: !login
                                  ? SignUp()
                                  : SignUpOption(
                                      onPressed: () =>
                                          setState(() => login = false),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => setState(() => login = true),
                    child: AnimatedContainer(
                      duration: duration,
                      curve: Curves.ease,
                      width: login
                          ? mediaQuery.size.width * 0.6
                          : mediaQuery.size.width * 0.4,
                      child: CustomPaint(
                        painter: CurvePainter(login, isPortrait),
                        child: Container(
                          padding: EdgeInsets.only(right: login ? 0 : 40),
                          child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                child: login
                                    ? Login()
                                    : LoginOption(
                                        onPressed: () =>
                                            setState(() => login = true),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => login = false),
                    child: AnimatedContainer(
                      duration: duration,
                      curve: Curves.ease,
                      width: login
                          ? mediaQuery.size.width * 0.4
                          : mediaQuery.size.width * 0.6,
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(left: login ? 40 : 0),
                        child: Center(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              child: !login
                                  ? SignUp()
                                  : SignUpOption(
                                      onPressed: () =>
                                          setState(() => login = false),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}