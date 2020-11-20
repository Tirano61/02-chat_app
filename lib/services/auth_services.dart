import 'dart:convert';
import 'package:chat_app/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/global/inviroment.dart';
import 'package:chat_app/models/login_response.dart';



import 'package:flutter/material.dart';

class AuthService with ChangeNotifier{

  Usuario usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor){
    this._autenticando = valor;
    notifyListeners();
  }

  static Future<String>  getToken()async{
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
    
  }
  static Future<void>  deleteToken()async{
    final _storage = new FlutterSecureStorage();
    final token = await _storage.delete(key: 'token');
    
  }


  Future<bool> login(String email, String password) async {

    this.autenticando = true;

    final data ={
      'email': email,
      'password': password
    };

    final resp = await http.post('${Enviroment.apiUrl}/login', 
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json'
      }
    );
    this.autenticando = false;

    if(resp.statusCode == 200){
      final loginResp = loginResponseFromJson(resp.body);
      this.usuario = loginResp.usuario;
      this._guardarToken(loginResp.token);
      return true;
    }else{
      return false;
    }

  }

  Future register(String name, String email, String password) async {
    this.autenticando = true;
    final data ={
      'nombre': name, 
      'email': email,
      'password': password
    };

    final resp = await http.post('${Enviroment.apiUrl}/login/new', 
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json'
      }
    );
    this.autenticando = false;

    if(resp.statusCode == 200){
      final loginResp = loginResponseFromJson(resp.body);
      this.usuario = loginResp.usuario;
      this._guardarToken(loginResp.token);
      return true;
    }else{
      final resBody = jsonDecode(resp.body);
      return resBody['msg'];
    }
  
  }

  Future<bool> isLogin(  ) async{

    final token = await this._storage.read(key: 'token');

    final resp = await http.get('${Enviroment.apiUrl}/login/renew', 
      headers:{
        'Content-type': 'application/json',
        'x-token': token
    });

    if(resp.statusCode == 200){
      final loginResp = loginResponseFromJson(resp.body);
      this.usuario = loginResp.usuario;
      this._guardarToken(loginResp.token);
      return true;
    }else{
      this._logOut();
      return false;
    }

  }


  Future _guardarToken(String token) async {

    return await _storage.write(key: 'token', value: token);
  }

  Future _logOut() async {
    await _storage.delete(key: 'token');
  }

}