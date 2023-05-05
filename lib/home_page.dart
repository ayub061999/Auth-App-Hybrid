import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Halo, ${user.email!.split("@").first}',
                style: TextStyle(
                    fontSize: 30
                ),),
              SizedBox(height: 10,),
              Text(user.email!,
                style: TextStyle(
                    fontSize: 14
                ),),
              SizedBox(height: 40,),
              ElevatedButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: Text('Logout',
                    style: TextStyle(
                        fontSize: 24
                    ),))
            ],
          ),
        ),
      ),
    );
  }
}
