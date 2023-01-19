import 'package:backend/backend.dart';
import 'package:backend/models/user_model.dart';

class UserSerializer extends Serializable {
  String? fullName;
  String? email;
  String? password;

  UserModel get userModel => UserModel.raw(
    email: email,
    fullName: fullName,
    password: password,
  );

  @override
  Map<String, dynamic>? asMap() =>{
    'fullName': fullName,
    'email': email,
    'password': password,
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    fullName = object['fullName']?.toString();
    email = object['email']?.toString();
    password = object['password']?.toString();
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String>? accept, Iterable<String>? ignore, Iterable<String>? reject, Iterable<String>? require}) {
    Iterable<String>? _reject = reject;

    // check if email is valid
    var regX = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if(object['email'] != null && !regX.hasMatch(object['email'].toString())){
      _reject = ['email'];
    }
    super.read(object, accept: accept, ignore: ignore, reject: _reject, require: require);
  }
  
}