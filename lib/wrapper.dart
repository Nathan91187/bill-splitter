import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/screens/Home/Home.dart';
import 'package:bill_splitter/screens/authentication/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if(user == null){
      return Authenticate();
    }
    return Home();
  }
}
