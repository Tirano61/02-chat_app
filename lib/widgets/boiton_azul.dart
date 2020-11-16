import 'package:flutter/material.dart';


class BotonAzul extends StatelessWidget {
  
  
  final String texto;
  final Function onPressed;

  const BotonAzul({Key key, this.texto, this.onPressed}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
            elevation: 2,
            highlightElevation: 5,
            color: Colors.blue,
            shape: StadiumBorder(),
            onPressed: 
              this.onPressed,
            
            child: Container(
              width: double.infinity,
              height: 55,
              child: Center(
                child: Text(this.texto, style: TextStyle(color: Colors.white,fontSize: 18),) ,
              ),
            ),
          );
  }
}