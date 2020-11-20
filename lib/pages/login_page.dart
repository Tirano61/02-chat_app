import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/widgets/boiton_azul.dart';
import 'package:chat_app/widgets/customLabel.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {


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
                Logo( titulo: 'Messenger',),
                _Form(),
                Labels(ruta: 'register',titulo: 'No tienes cuenta?',subTitulo: 'Crea una ahora !',),
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

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: true);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          
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
            onPressed: authService.autenticando ? null : () async{
              
              final loginOK = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());

              if(loginOK){
                //TODO: Conectar al socketServer
                Navigator.pushReplacementNamed(context, 'usuario');
              }else{
                 mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales'); 
              }

            },
            texto: 'Ingresar',),
        ],
      ),
    );
  }






}

