import 'package:backend/backend.dart';
import 'package:backend/models/user_model.dart';
import 'package:backend/serializers/user_serializer.dart';

class UserController extends ResourceController {
  UserModel userModel = UserModel(email: 'email', hashedPassword: 'hashedPassword');
  @Operation.get()
  Future<Response> getAllUsers() async {
    return (await userModel.getAll(excludeFields: ['hashedPassword', 'salt'])).asHttpResponse;
  }
  @Operation.post()
  Future<Response> createUser(@Bind.body(require: ['fullName', 'email', 'password']) UserSerializer serializer) async {
    final UserModel _userModel = serializer.userModel;
    return (await _userModel.create()).asHttpResponse;
  }
  @Operation.put('email')
  Future<Response> upddateUser(@Bind.path('email') String email, @Bind.body() UserSerializer serializer) async {
    final UserModel _userModel = serializer.userModel;
    return (await _userModel.updateByEmail(email)).asHttpResponse;
  }
  @Operation.delete('email')
  Future<Response> deleteUser(@Bind.path('email') String email,) async {
    return (await userModel.deleteByEmail(email)).asHttpResponse;
  }
}