
import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// [ModelManager] connects the API with the database.
/// [create] saves the usermodel to the database
/// [getAll] fetches all users
/// [getOneByEmail] fetches one user filtering by email
/// [updateByEmail] updates a user filtering by email
/// [deleteByEmail] deletes a user from DB using email
class ModelManager {
  ModelManager(this.tableName);
  String tableName;

  Db db = Db("mongodb://localhost:27017/posta_test");
  Future<DbCollection> get collection async{
    await db.open();
    return db.collection(tableName);
  }

  ObjectId? _id;
  String get id => _id!.toJson();
  void openDb()async{
    await db.open();
    
  }

  Map<String, dynamic> asMap()=>{};

  Future<DBResponse> create()async{
    try {
      await (await collection).insert(asMap());
      return DBResponse(type: DBResponseType.success, message: 'Creating user was successful');
    } catch (e) {
      return DBResponse(type: DBResponseType.warning, message: e.toString());
    }
  }

  Future<DBResponse> getAll({List<String> excludeFields = const[]})async{
    
    try {
      final dbRes = await (await collection).find(where.excludeFields(excludeFields)).toList();
      return DBResponse(type: DBResponseType.success, message: dbRes);
    } catch (e) {
      return DBResponse(type: DBResponseType.warning, message: e.toString());
    }
  }

  Future<DBResponse> getOneByEmail(String email, {List<String> excludeFields = const[]})async{
    try {
      final dbRes = await (await collection).findOne(where.eq('email', email).excludeFields(excludeFields));
      return DBResponse(type: DBResponseType.success, message: dbRes);
    } catch (e) {
      return DBResponse(type: DBResponseType.warning, message: e.toString());
    }
  }

  Future<DBResponse> updateByEmail(String email)async{
    
    try {
      await (await collection).findAndModify(query: where.eq('email', email), update: asMap());
      return DBResponse(type: DBResponseType.success, message: 'Updating user was successful');
    } catch (e) {
      return DBResponse(type: DBResponseType.warning, message: e.toString());
    }
  }

  Future<DBResponse> deleteByEmail(String email)async{
    
    try {
      await (await collection).deleteOne(where.eq('email', email));
      return DBResponse(type: DBResponseType.success, message: 'Deleting user was successful');
    } catch (e) {
      return DBResponse(type: DBResponseType.warning, message: e.toString());
    }
    
  }
}

/// [DBResponse] database response
class DBResponse{
  DBResponse({required this.type, this.message});
  final DBResponseType type;
  final dynamic message;

  Response get asHttpResponse {
    switch (type) {
      case DBResponseType.success:
          return Response.ok(message);
        
      case DBResponseType.warning:
          return Response.badRequest(body: message);
        
      default:
      return Response.serverError(body: message);
    }
  }
}

enum DBResponseType{
  success, error, warning
}