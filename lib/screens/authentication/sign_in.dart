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
        backgroundColor: Colors.grey,
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
             backgroundColor: Colors.grey,
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
               Container(
                 margin: const EdgeInsets.only(bottom: 10),
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: const Color(0xFF111111),
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all( color: Colors.amber,)
                 ),
                 child: TextFormField(
                   onChanged: (val) => email = val,
                   decoration: textFieldDecoration.copyWith(hintText: "Email"),
                     validator: (val) {
               if(val == null || val.isEmpty){
               return "Email can't be empty";
               }
               final emailRegex = RegExp(
                 r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
               );

               if (!emailRegex.hasMatch(val.trim())) {
                 return "Enter a valid email";
               }
               return null;
               },
                 ),
               ),
               SizedBox(height: 20),
               Container(
                 margin: const EdgeInsets.only(bottom: 10),
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: const Color(0xFF111111),
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(
                     color: Colors.amber,
                   )
                 ),
                 child: TextFormField(
                   obscureText: true,
                   onChanged: (val) => password = val,
                   decoration: textFieldDecoration.copyWith(hintText: "Password"),
                   validator: (val) {
                     if (val == null || val.trim().length < 6){
                       return "Please enter a password longer than 5 characters";
                     }
                     return null;
                   },
                 ),
               ),
               SizedBox(height: 20),
               ElevatedButton(
                   onPressed: () async {

                     if(_formkey.currentState!.validate()){
                       setState((){
                         loading = true;
                       });
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