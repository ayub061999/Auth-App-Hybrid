import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_auth_app/utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Silahkan masukkan email \nuntuk mereset password",
                textAlign: TextAlign.center,
                style: (TextStyle(fontSize: 24)),
              ),
              SizedBox(
                height: 20,
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
                height: 20,
              ),
              ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('Silahkan cek email untuk mereset password');
      Navigator.of(context).popUntil((route) => route.isFirst);
    }on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
