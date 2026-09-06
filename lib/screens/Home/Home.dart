import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:bill_splitter/screens/Home/add_bill_form.dart';
import 'package:bill_splitter/widgets/billList.dart';
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
        backgroundColor: Colors.grey,
        title: Text("Bill Splitter"),
        actions: [
          FilledButton.icon(
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
            style: FilledButton.styleFrom(
                backgroundColor: Colors.grey,
                elevation: 0
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: BillList()
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.amber,
                width: 3
          )
        ),
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => AddBillForm()
          )
          );
        },
            backgroundColor: Colors.black,
            child: Icon(
              Icons.add,
              color: Colors.amber,
            ),
      ),
    );
  }
}
