import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileGooglePage extends StatefulWidget {
  final GoogleSignInAccount user;
  const ProfileGooglePage(this.user, {Key? key}) : super(key: key);

  @override
  _ProfileGooglePageState createState() => _ProfileGooglePageState();
}

class _ProfileGooglePageState extends State<ProfileGooglePage> {  

  @override
  Widget build(BuildContext context) {
    final name = widget.user.displayName;
    final email = widget.user.email;
    final image = widget.user.photoUrl;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              image!,
            ),
            radius: 100,
          ),
          SizedBox(height: 20),
          Text(
            'User: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '$name',
            style: TextStyle(fontSize: 20, color: Colors.blueGrey),
          ),
          SizedBox(height: 30),
          Text('Email: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('$email',
              style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
          SizedBox(height: 30),
          ElevatedButton(
            child: Text('Logout'),
            onPressed: () async {
              await GoogleSignIn().signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
