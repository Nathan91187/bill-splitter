import 'package:bill_splitter/screens/authentication/Register.dart';
import 'package:bill_splitter/screens/authentication/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
   Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
   bool showSignIn = true;

   void toggleScreens(){
     setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override

  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggle: toggleScreens);
    }
    else{
      return Register(toggle: toggleScreens);
  }
}
}
