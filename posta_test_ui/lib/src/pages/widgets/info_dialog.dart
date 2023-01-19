import 'package:flutter/material.dart';
import 'package:posta_test_ui/src/modules/users_module.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({required this.response, super.key});
  final ApiResponse response;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 30,
          color: response.wasSuccessful ? Colors.greenAccent : Colors.redAccent,
        ),
        const SizedBox(height: 30,),
        Text(response.message),
        const SizedBox(height: 15,),
        ElevatedButton(
          onPressed: ()=> Navigator.of(context).pop(), 
          child: const Text('close')
        ),
        const SizedBox(height: 15,)
      ],
    );
  }
}