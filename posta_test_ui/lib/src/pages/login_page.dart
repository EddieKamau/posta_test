import 'package:flutter/material.dart';
import 'package:posta_test_ui/src/modules/users_module.dart';
import 'package:posta_test_ui/src/pages/users_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  UsersModule usersModule = UsersModule();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Posta Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email'
                ),
              ),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Passoword'
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  var res = await usersModule.login(emailController.text, passwordController.text);
                  if(res.wasSuccessful){
                    if(mounted)Navigator.push(context, MaterialPageRoute(builder: (_)=> const UsersPage()));
                  }
                }, 
                child: const Text('Login')
              )
            ],
          ),
        ),
      ),
    );
  }
}