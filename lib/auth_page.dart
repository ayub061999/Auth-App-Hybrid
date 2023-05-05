import 'package:flutter/material.dart';
import 'package:new_auth_app/login_page.dart';
import 'package:new_auth_app/register_page.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(onClickedSignUp: toggle)
      : RegisterPage(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
