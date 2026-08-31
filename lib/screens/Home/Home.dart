import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = AuthService();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          ElevatedButton.icon(
              onPressed: () async{
                setState(() {
                  loading = true;
                });
            await auth.signOut();
          },
              label: Text("SignOut"),
              icon: Icon(Icons.person),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Text("hello"),
      ),
    );
  }
}
