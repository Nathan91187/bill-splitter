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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Bill Splitter"),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
            },
            label: Text(
              "Add Bill",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                elevation: 0
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              auth.signOut();
            },
            label: Text(
              "Sign Out",
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: Text("hello"),
      ),
    );
  }
}
