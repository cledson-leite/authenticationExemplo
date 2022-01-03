import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/user/dashboard_page.dart';
import 'package:flutter_firebase_app/user/profile_google_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserGooglePage extends StatefulWidget {
  final GoogleSignInAccount user;
  const UserGooglePage(this.user, {Key? key}) : super(key: key);

  @override
  _UserGooglePageState createState() => _UserGooglePageState();
}

class _UserGooglePageState extends State<UserGooglePage> {
  int _selectedIndex = 0;

  _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
  List<Widget> _widgetOption = [
    DashboardPage(),
    ProfileGooglePage(widget.user),
  ];
    return Scaffold(
      body: _widgetOption.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey,
        selectedFontSize: 18,
        onTap: _onTap,
      ),
    );
  }
}
