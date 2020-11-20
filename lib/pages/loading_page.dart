import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) { 
          return Center(
            child: Text('Autenticando ...'),
          );
        },
      ),
    );
  }


  Future checkLoginState(BuildContext context) async {

    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLogin();

    if(autenticado){
      //TODO: conectar al socket
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => UsuariosPage(),
      ));
    }else{
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginPage(),
      ));
    }

  }


}