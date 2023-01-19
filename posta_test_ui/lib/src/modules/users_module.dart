import 'dart:convert';

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:http/http.dart' as http;
import 'package:posta_test_ui/src/models/user_model.dart';

const String url = 'http://127.0.0.1:8888/users';

class UsersModule  extends ChangeNotifier{
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  void fetchUsers()async{
    try {
      http.Response res = await http.get(Uri.parse(url));
      if(res.statusCode == 200){
        
        List<Map> rawUsers = List.from(json.decode(res.body) as List);
        _users = rawUsers.map((u)=> UserModel.fromMap(u)).toList();
        notifyListeners();
        
      }
    } catch (e) {
        return;
      }
  }

  Future<ApiResponse> createUser(UserModel user, String password)async{
    try {
      http.Response res = await http.post(Uri.parse(url), body: json.encode({...user.asMap(), 'password': password}), headers: {
        'Content-Type': 'application/json'
      });
      fetchUsers();
      if(res.statusCode == 200){
        return ApiResponse(wasSuccessful: true, message: res.body);
      }
      return ApiResponse(wasSuccessful: false, message: res.body);
    } catch (e) {
      return ApiResponse(wasSuccessful: false, message: e.toString());
    }
  }

  Future<ApiResponse> updateUser(UserModel user, {String? password})async{
    String email = user.email ?? '';
    try {
      http.Response res = await http.put(Uri.parse('$url/$email'), body: json.encode({...user.asMap(), if(password != null) 'password': password}), headers: {
        'Content-Type': 'application/json'
      });
      fetchUsers();
      if(res.statusCode == 200){
        return ApiResponse(wasSuccessful: true, message: res.body);
      }
      return ApiResponse(wasSuccessful: false, message: res.body);
    } catch (e) {
      return ApiResponse(wasSuccessful: false, message: e.toString());
    }
  }

  Future<ApiResponse> deleteUser(String email)async{
    try {
      http.Response res = await http.delete(Uri.parse('$url/$email'));
      fetchUsers();
      if(res.statusCode == 200){
        return ApiResponse(wasSuccessful: true, message: res.body);
      }
      return ApiResponse(wasSuccessful: false, message: res.body);
    } catch (e) {
      return ApiResponse(wasSuccessful: false, message: e.toString());
    }
  }
}

class ApiResponse{
  ApiResponse({required this.wasSuccessful, required this.message});
  bool wasSuccessful;
  String message;
}