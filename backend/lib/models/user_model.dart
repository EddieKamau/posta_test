import 'package:backend/models/model_manager.dart';
import 'package:conduit_password_hash/conduit_password_hash.dart';

class UserModel extends ModelManager{
  UserModel({required this.email, required this.hashedPassword, this.fullName, this.salt}): super('users');
  UserModel.raw({this.email, String? password, this.fullName, }): super('users'){
    if(password != null){
      final generator = PBKDF2();
      salt = generateAsBase64String(16);
      hashedPassword = generator.generateBase64Key(password, salt!, 1000, 32);
    }
    
  }
  String? fullName;
  String? email;
  String? hashedPassword;
  String? salt;

  @override
  Map<String, dynamic> asMap()=>{
    if(fullName != null) 'fullName': fullName,
    if(email != null) 'email': email,
    if(hashedPassword != null) 'hashedPassword': hashedPassword,
    if(salt != null) 'salt': salt,
  };

  bool verifyPassword(String password){
    final generator = PBKDF2();
    final String _hashedPassword = generator.generateBase64Key(password, salt!, 1000, 32);
    return _hashedPassword == hashedPassword;
  }
}