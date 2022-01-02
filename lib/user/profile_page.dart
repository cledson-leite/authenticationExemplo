import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.amber.shade400,
        content: Text('Email de verificação foi enviado'),
      ));
    }
    user!.emailVerified;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              'images/profile.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'User Id: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '$uid',
            style: TextStyle(fontSize: 20, color: Colors.blueGrey),
          ),
          SizedBox(height: 30),
          Text('Email: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('$email',
              style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
          SizedBox(height: 10),
          user!.emailVerified
              ? Text('Email Verificado',
                  style: TextStyle(color: Colors.green.shade800))
              : TextButton(
                  child: Text('Vericar Email'),
                  onPressed: verifyEmail,
                ),
          SizedBox(height: 30),
          Text('Creation Time: ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(creationTime.toString(),
              style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Logout'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
