import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_auth_app/utils.dart';

import 'main.dart';

class RegisterPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const RegisterPage({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confPassController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  bool validatePassword(String pass){
    String _password = pass.trim();
    if(!pass_valid.hasMatch(_password)){
      return true;
    }else{
      return false;
    }
  }

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
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              'REGISTER',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Email tidak valid'
                      : null,
            ),
            SizedBox(
              height: 4,
            ),
            TextFormField(
              controller: passController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (pass) {
                if(pass!.isEmpty || pass.length <8){
                  return "Masukan password minimal 8 karakter!";
                } else {
                    if (validatePassword(pass)) {
                      return "Password harus terdiri dari huruf besar, huruf kecil, dan angka!";
                    } else {
                      return null;
                    }
                }
              },
            ),
            SizedBox(
              height: 4,
            ),
            TextFormField(
              controller: confPassController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Konfirmasi Password'),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (pass) {
                if(pass != passController.text.trim()){
                  return "Konfirmasi password tidak sesuai";
                } else {
                  return null;
                }
              } ,
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: signUp,
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              child: Text('Register'),
            ),
            SizedBox(
              height: 30,
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    text: 'Sudah punya akun? ',
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Log in',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary))
                ]))
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
