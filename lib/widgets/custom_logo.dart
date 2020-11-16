
import 'package:flutter/material.dart';


class Logo extends StatelessWidget {
  
  final String titulo;

  const Logo({Key key, @required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          width: 170,
          child: Column(
            children: <Widget>[
              Image(image: AssetImage('assets/tag-logo.png')),
              Text(titulo, style: TextStyle(fontSize: 30),),
            ],
          ),
        ),
      ),
    );
  }
}