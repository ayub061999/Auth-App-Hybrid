import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'forgot_password_page.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            'LOGIN',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(
            height: 4,
          ),
          TextField(
            controller: passController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: signIn,
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            child: Text('Login'),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            child: Text(
              'Lupa Password',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20),
            ),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ForgotPasswordPage())),
          ),
          SizedBox(
            height: 30,
          ),
          RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  text: 'Belum punya akun? ',
                  children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: 'Daftar disini',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary))
              ]))
        ],
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
