import 'package:bill_splitter/screens/authentication/authenticate.dart';
import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/shared/common.dart';
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
        backgroundColor: Colors.amber,
        title: Text("Register"),
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
                  decoration: textFieldDecoration.copyWith(hintText: "Email"),
                validator: (val) {
                    if(val == null || val.isEmpty){
                      return "Email can't be empty";
                    }
                    return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                onChanged: (val) => password = val,
                decoration: textFieldDecoration.copyWith(hintText: "Password"),
                validator: (val) {
                  if (val == null || val.length < 6){
                    return "Please enter a password longer than 5 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                      setState((){
                    loading = true;
                  });
                  if(_formkey.currentState!.validate()) {
                    final user = await auth.register(email, password);
                  if(user == null) {
                    setState(() {
                      loading = false;
                      error = "Please enter valid credentials";
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