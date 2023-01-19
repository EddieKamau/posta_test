// import 'package:backend/backend.dart';
// import 'package:backend/models/model_manager.dart';
// import 'package:backend/models/user_model.dart';

// class PasswordValidator extends AuthValidator {
//   FutureOr<Authorization?>? validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope>? requiredScope})  async {

//     final List<String> inputs = authorizationData.toString().split(':');
//     if(inputs.length == 2){
//       final UserModel userModel = UserModel(email: 'email', hashedPassword: 'hashedPassword');
//       final dbRes = await userModel.getOneByEmail(inputs[0]);
//       if(dbRes.type == DBResponseType.success){
//         final user = UserModel(
//           email: dbRes.message['email'].toString(), 
//           hashedPassword: dbRes.message['hashedPassword'].toString(),
//           salt: dbRes.message['hashedPassword'].toString(),
//         );

//         if(user.verifyPassword(inputs[1])){
//           return Authorization(null, 0, this);
//         }
//       }
//     }
//     return null;
//   }
  
// }