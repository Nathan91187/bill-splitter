import 'package:bill_splitter/data/auth_errors.dart';
import 'package:bill_splitter/screens/authentication/authenticate.dart';
import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/shared/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/loading.dart';

class Register extends StatefulWidget {
  Register({super.key, required this.toggle});

  final Function toggle;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  final authenticate = Authenticate();

  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
            "Register",
            style: TextStyle(
              fontWeight: FontWeight.w600
            ),
        ),
        actions: [
          ElevatedButton.icon(
          onPressed: (){
          widget.toggle();
    },
            label: Text(
                "Sign in",
                style: TextStyle(
                  color: Colors.black
                ),
            ),
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
                  border: Border.all(
                    color: Colors.amber,
                  )
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
                  if(_formkey.currentState!.validate()) {
                    setState((){
                      loading = true;
                      error = '';
                    });
                    try {
                      await auth.register(email.trim(), password);
                    }on FirebaseAuthException catch (e) {
                      setState(() {
                        loading = false;
                        error = AuthErrors().authErrorMessages[e.code] ?? 'Something went wrong. Please try again.';
                      });
                    }
                }},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber
                ),
                child: Text(
                  "Register",
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