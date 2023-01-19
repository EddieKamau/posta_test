class UserModel {
  UserModel.fromMap(Map map){
    id = map['_id']?.toString();
    fullName = map['fullName'];
    email = map['email'];
  }
  UserModel({this.fullName, this.email});
  String? id;
  String? fullName;
  String? email;

  Map<String, dynamic> asMap()=> {
    if(fullName != null) 'fullName': fullName,
    if(email != null) 'email': email,
  };
}