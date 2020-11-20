import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {


  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuario = [
    Usuario(uid: '1' ,nombre: 'Dario', email: 'test1@test.com', online: true ),
    Usuario(uid: '1' ,nombre: 'Mauricio', email: 'test2@test.com', online: false ),
    Usuario(uid: '1' ,nombre: 'Ariel', email: 'test3@test.com', online: true ),  
  ];

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar:  AppBar(
        title: Text(authService.usuario.nombre,style: TextStyle(color: Colors.black45),),
        elevation: 2,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app,color: Colors.blue,), 
          onPressed: (){
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          }),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            //schild: Icon(Icons.check_circle, color: Colors.green[400]),
            child: Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color:  Colors.blue[200],),
          waterDropColor: Colors.blue[400],
        ),
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => _crearListTile(usuario[index]),
      separatorBuilder: (_ , i) => Divider(),
      itemCount: usuario.length,

    );
  }

  ListTile _crearListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }


  _cargarUsuarios()async{

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();


  }

}

