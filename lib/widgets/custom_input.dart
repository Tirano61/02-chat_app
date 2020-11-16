import 'package:flutter/material.dart';


class CustomInput extends StatelessWidget {
  

  final IconData icon;
  final String placeHolder;
  final TextEditingController textEditingController;
  final TextInputType keyBoardType;
  final bool isPassword;

  const CustomInput({
    Key key, 
    @required this.icon, 
    @required this.placeHolder, 
    @required this.textEditingController, 
    this.keyBoardType = TextInputType.emailAddress, 
    this.isPassword = false}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 5),
                  blurRadius: 5,
                ),
              ],
            ),
            child: TextField(
              controller: this.textEditingController,
              autocorrect: false,
              keyboardType: keyBoardType,
              obscureText: (isPassword) ? true : false,
              decoration: InputDecoration(
                prefixIcon: Icon(this.icon,color: Colors.blue,),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: this.placeHolder
                
              ),
            ),
          );
  }
}