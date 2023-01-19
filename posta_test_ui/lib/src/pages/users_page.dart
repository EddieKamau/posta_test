import 'package:flutter/material.dart';
import 'package:posta_test_ui/src/models/user_model.dart';
import 'package:posta_test_ui/src/modules/users_module.dart';
import 'package:posta_test_ui/src/pages/widgets/info_dialog.dart';
import 'package:posta_test_ui/src/pages/widgets/user_dialog_widget.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  UsersModule usersModule = UsersModule();
  List<UserModel> users = [
    UserModel()
  ];

  @override
  void initState() {
    super.initState();
    usersModule.addListener(() {
      setState(() {
        users = usersModule.users;
      });
    });
    usersModule.fetchUsers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Users'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // add user dialog
          showDialog(
            context: context, 
            builder: (_)=> Dialog(child: UserDialog(usersModule: usersModule, isCreatingNew: true,),)
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, index){
          return Card(
            key: ValueKey(users[index].id ?? ''),
            child: ListTile(
              onLongPress: (){
                // edit delete dialog
                showDialog(
                  context: context, 
                  builder: (dialogContext){
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              onPressed: () async {
                                final res = await usersModule.deleteUser(users[index].email ?? '');
                                if(mounted){
                                  Navigator.of(dialogContext).pop();
                                }

                                showDialog(
                                  context: context, 
                                  builder: (_)=> Dialog(child: InfoDialog(response: res,),)
                                );

                              }, 
                              child: const Text('Delete')
                            ),

                            ElevatedButton(
                              onPressed: (){
                                Navigator.of(dialogContext).pop();
                                showDialog(
                                  context: context, 
                                  builder: (_)=> Dialog(child: UserDialog(
                                    usersModule: usersModule,
                                    userToEdit: users[index],
                                    isCreatingNew: false,
                                  ),)
                                );
                              }, 
                              child: const Text('Edit')
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
              title: Text(users[index].fullName ?? ''),
              subtitle: Text(users[index].email ?? ''),
            ),
          );
        }
      ),
    );
  }
}