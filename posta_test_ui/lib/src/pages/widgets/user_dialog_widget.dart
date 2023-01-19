import 'package:flutter/material.dart';
import 'package:posta_test_ui/src/models/user_model.dart';
import 'package:posta_test_ui/src/modules/users_module.dart';
import 'package:posta_test_ui/src/pages/widgets/info_dialog.dart';

class UserDialog extends StatefulWidget {
  const UserDialog({required this.usersModule, this.userToEdit, this.isCreatingNew = true, super.key});
  final bool isCreatingNew;
  final UsersModule usersModule;
  final UserModel? userToEdit;

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // errors
  bool nameRequired = false;
  bool emailRequired = false;
  bool passwordRequired = false;
  bool passwordMisMatch = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userToEdit?.fullName);
    emailController = TextEditingController(text: widget.userToEdit?.email);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // name field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              onChanged: (_){
                setState(() {
                  nameRequired = false;
                });
              },
              decoration: InputDecoration(
                labelText: 'Full Name',
                errorText: nameRequired ? '*Required' : null
              ),
            ),
          ),
          // email field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              onChanged: (_){
                setState(() {
                  emailRequired = false;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: emailRequired ? '*Required' : null
              ),
            ),
          ),
          // password field
          if(widget.isCreatingNew) Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              onChanged: (_){
                setState(() {
                  passwordRequired = false;
                  passwordMisMatch = false;
                });
              },
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: passwordRequired ? '*Required' : null
              ),
            ),
          ),
          if(widget.isCreatingNew) Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: confirmPasswordController,
              obscureText: true,
              onChanged: (_){
                setState(() {
                  passwordMisMatch = false;
                });
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: passwordMisMatch ? '*Password missmatch' : null
              ),
            ),
          ),

          // actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }, 
                child: const Text('Back')
              ),


              ElevatedButton(
                onPressed: () async {
                  // check fields
                  bool rebuild = false;
                  if(nameController.text == ''){
                    nameRequired = true;
                    rebuild = true;
                  }
                  if(emailController.text == ''){
                    emailRequired = true;
                    rebuild = true;
                  }
                  if(passwordController.text == '' && widget.isCreatingNew){
                    passwordRequired = true;
                    rebuild = true;
                  }
                  if(passwordController.text != confirmPasswordController.text && widget.isCreatingNew){
                    passwordMisMatch = true;
                    rebuild = true;
                  }
                  

                  if(rebuild){
                    setState(() {
                      
                    });

                    return;
                  }

                  // add or update
                  if(widget.isCreatingNew){
                    final res = await widget.usersModule.createUser(
                      UserModel(fullName: nameController.text, email: emailController.text), 
                      passwordController.text 
                    );
                    if(mounted){
                      Navigator.of(context).pop();
                    }
                    showDialog(
                      context: context, 
                      builder: (_)=> Dialog(child: InfoDialog(response: res,),)
                    );
                  }else{
                    final res = await widget.usersModule.updateUser(UserModel(fullName: nameController.text, email: emailController.text), );

                    if(mounted){
                      Navigator.of(context).pop();
                    }
                    showDialog(
                      context: context, 
                      builder: (_)=> Dialog(child: InfoDialog(response: res,),)
                    );
                  }
                }, 
                child: Text(widget.isCreatingNew ? 'Create' : 'Update')
              )
            ],
          )
        ],
      ),
    );
  }
}