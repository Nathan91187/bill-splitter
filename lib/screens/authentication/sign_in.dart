import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/shared/common.dart';
import 'package:flutter/material.dart';

import '../../shared/loading.dart';

class SignIn extends StatefulWidget {
   SignIn({super.key, required this.toggle});

  final Function toggle;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Sign in"),
        actions: [
         ElevatedButton.icon(
          onPressed: (){
            widget.toggle();
          },
                  label: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.black
                    )),
                  icon: Icon(
                      Icons.person,
                      color: Colors.black,
                  ),
           style: ElevatedButton.styleFrom(
             backgroundColor: Colors.amber,
             elevation: 0
           ),
         )
        ],
      ),
     body: Padding(
       padding: const EdgeInsets.all(10.0),
       child: Form(
         key: _formkey,
           child: Column(
             children: [
               SizedBox(height: 20),
               TextFormField(
                 onChanged: (val) => email = val,
                 decoration: textFieldDecoration.copyWith(hintText: "Email")
               ),
               SizedBox(height: 20),
               TextFormField(
                 obscureText: true,
                 onChanged: (val) => password = val,
                 decoration: textFieldDecoration.copyWith(hintText: "Password"),
               ),
               SizedBox(height: 20),
               ElevatedButton(
                   onPressed: () async {
                     setState((){
                       loading = true;
                     });
                     if(_formkey.currentState!.validate()){
                       final user = await auth.signInWithEmailAndPassword(email, password);
                       if(user == null){
                          setState(() {
                            loading = false;
                            error = "User Not Found";
                          });
                       }
                     }
                   },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber
                  ),
                   child: Text(
                       "Sign in",
                        style: TextStyle(
                          color: Colors.black
                        ),
                   ),
                   ),
               SizedBox(height: 12),
               Text(
                 error,
                 style: TextStyle(
                   color: Colors.red
                 ),
               )
             ],
           ),
       ),
     ),
    );
}
}