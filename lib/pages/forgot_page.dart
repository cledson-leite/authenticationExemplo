import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'signup_page.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';

  _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[900],
        content: Text(
          'Link para resert de senha enviado para o email',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
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
      appBar: AppBar(title: Text("Reset da Senha"),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset('images/forget.jpg'),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Enviaremos um link para o email cadastrado',
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(height: 20),
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
              Center(
                child: ElevatedButton(
                  child: Text(
                    'Enviar',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _resetPassword();
                    }
                  },
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
                        pageBuilder: (ctx, _, __) => SignupPage(),
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
