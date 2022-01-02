import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/login_page.dart';
import 'package:flutter_firebase_app/pages/user_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  String newPassword = '';

  Future<void> _changePass() async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[900],
        content: Text(
          'Cadastro feito com sucesso',
          style: TextStyle(fontSize: 18),
        ),
      ),);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
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
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[600],
          content: Text(
            'Falha inesperada.\nPor favor, tente novamente em breve ...',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
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
                child: Image.asset('images/change.jpg'),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Nova senha',
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 15,
                    ),
                  ),
                  onSaved: (newPassword) => this.newPassword = newPassword!,
                  validator: (newPassword) {
                    if (newPassword == null || newPassword.isEmpty)
                      return 'Senha é obrigatório';

                    if (newPassword.length < 6)
                      return 'Senha com minimo 6 caracteres';

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
                        _changePass();
                      }
                    },
                  ),
                ),
              ),
              TextButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => UserPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
