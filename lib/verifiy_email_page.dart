import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_auth_app/home_page.dart';
import 'package:new_auth_app/utils.dart';

class VerifyEmailPage extends StatefulWidget {

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState(){
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();
      
      timer = Timer.periodic(Duration(seconds: 3), (_) {
        checkEmailVerified();
      });
    }
  }

  @override
  void dispose(){
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async{
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);

    } catch (e){
      Utils.showSnackBar(e.toString());
    }

  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
    appBar: AppBar(
      title: Text('Verify Email'),
    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Email verifikasi telah terkirim.",
            textAlign: TextAlign.center,
            style: (TextStyle(fontSize: 24)),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: canResendEmail ? sendVerificationEmail : null,
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            child: Text('Verifikasi Email'),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            child: Text('Batal'),
          ),
        ],
      ),
    ),
  );
}
