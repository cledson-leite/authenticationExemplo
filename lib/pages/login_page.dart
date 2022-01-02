import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forgot_page.dart';
import 'signup_page.dart';
import 'user_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  _userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => UserPage()));
    } on FirebaseAuthException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red[600],
        content: Text(
          'Usuário não encontrado',
          style: TextStyle(fontSize: 18),
        ),
      ));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red[600],
        content: Text(
          'Falha inesperada.\nPor favor, tente novamente em breve ...',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset('images/login.jpg'),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 15,
                    ),
                  ),
                  onSaved: (email) => this.email = email!,
                  validator: (email) {
                    if (email == null || email.trim().isEmpty)
                      return 'Email é obrigatório';

                    if (!email.contains('@') || !email.contains('.com'))
                      return 'Email invalido';

                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 15,
                    ),
                  ),
                  onSaved: (password) => this.password = password!,
                  validator: (password) {
                    if (password == null || password.isEmpty)
                      return 'Senha é obrigatório';

                    if (password.length < 6)
                      return 'Senha com minimo 6 caracteres';

                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _userLogin();
                        }
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Esqueci minha senha',
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ForgotPage()));
                      },
                    ),
                  ],
                ),
              ),
              TextButton(
                child: Text(
                  'Ainda não tem conta?',
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (ctx, _, __) => SignupPage(), transitionDuration: Duration(seconds: 0)), (route) => false,
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
