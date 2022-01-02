import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'user_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  String email = '';
  String password = '';

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }

  _userRegister() async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => UserPage()));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[600],
          content: Text(
            'Senha muito fraca',
            style: TextStyle(fontSize: 18),
          ),
        ));
      }
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[600],
          content: Text(
            'Já existe um cadastro com esse email',
            style: TextStyle(fontSize: 18),
          ),
        ));
      }
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
                child: Image.asset('images/signup.png'),
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
                  controller: passwordController,
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
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm',
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 15,
                    ),
                  ),
                  onSaved: (_) => this.password = passwordController.text,
                  validator: (confirm) {
                    if (confirm == null || confirm.isEmpty)
                      return 'Confirmação de senha obrigatório';

                    if (confirm != passwordController.text)
                      return 'Senhas não confere';

                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: ElevatedButton(
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _userRegister();
                      }
                    },
                  ),
                ),
              ),
              TextButton(
                child: Text(
                  'Já tem conta?',
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (ctx, _, __) => LoginPage(),
                        transitionDuration: Duration(seconds: 0)),
                    (route) => false,
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
