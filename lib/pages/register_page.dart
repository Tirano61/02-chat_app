import 'package:chat_app/widgets/boiton_azul.dart';
import 'package:chat_app/widgets/customLabel.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(titulo: 'Register',),
                _Form(),
                Labels(ruta: 'login',titulo: 'Ya tienes una cuenta?',subTitulo: 'Ingresa ahora !'),
                Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _Form  extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form > {
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre',
            keyBoardType: TextInputType.text,
            textEditingController: nombreCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo electrónico',
            keyBoardType: TextInputType.emailAddress,
            textEditingController: emailCtrl,
          ),
          CustomInput(
            isPassword: true,
            icon: Icons.https_outlined,
            placeHolder: 'Password',
            keyBoardType: TextInputType.text,
            textEditingController: passCtrl,
          ),
          BotonAzul(
            onPressed: (){
              print(emailCtrl.text);
              print(passCtrl.text);
            },
            texto: 'Ingresar',),
          
        ],
      ),
    );
  }
}

