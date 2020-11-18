
import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;
  

List<ChatMessage> _mensajes =[

];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text('Te', style:  TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3,),
            Text('Melissa Flores', style: TextStyle(color: Colors.black45,fontSize: 12)),
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
    final newChatMessage = new ChatMessage(uid: '123',texto: texto,
    animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 700)),);
    _mensajes.insert(0, newChatMessage);
    newChatMessage.animationController.forward();
    });
    _estaEscribiendo = false;  
  }



}