
import 'dart:io';

import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _mensajes =[];

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioPara.uid);
  }


  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioId);
    final history = chat.map((m) => new ChatMessage(
      texto: m.mensaje, 
      uid: m.de, 
      animationController: new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 0)
      )..forward()
    ));

    setState(() {
      _mensajes.insertAll(0, history);
    });

  }

  void _escucharMensaje( dynamic payload ){
    ChatMessage message = new ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200))
      );
      setState(() {
        _mensajes.insert(0, message);
      });
      message.animationController.forward();
  }


  @override
  Widget build(BuildContext context) {

    
    final usuarioPara = chatService.usuarioPara;


    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
        
          children: <Widget>[
            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0,2), style:  TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text(usuarioPara.nombre, style: TextStyle(color: Colors.black45,fontSize: 12)),
          ],
        ),
      ),
      body: Container(
        
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: _mensajes.length,
                itemBuilder: (_, i) => _mensajes[i],
                reverse: true,
              ),
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _inputChat(){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto){
                  setState(() {
                    if (texto.trim().length > 0) {
                      _estaEscribiendo = true;
                    }else{
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),

            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS 
              ? CupertinoButton(
                child: Text('Enviar'),
                onPressed: _estaEscribiendo
                    ? () => _handleSubmit(_textController.text.trim())
                    : null,
              )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: IconTheme(
                    data: IconThemeData(
                      color: Colors.blue[400], 
                    ),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      icon: Icon(Icons.send),
                      color: Colors.blue[400],

                    onPressed: _estaEscribiendo
                    ? () => _handleSubmit(_textController.text.trim())
                    : null,
                ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto){

    if(texto.length == 0) return;
    setState(() {
    _focusNode.requestFocus();
    _textController.clear();
    final newChatMessage = new ChatMessage(uid: authService.usuario.uid,texto: texto,
    animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 700)),);
    _mensajes.insert(0, newChatMessage);
    newChatMessage.animationController.forward();
    });
    _estaEscribiendo = false;  
    this.socketService.emit('mensaje-personal',{
      'de': authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }



  @override
  void dispose() {
    
    for(ChatMessage message in _mensajes){
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  

}