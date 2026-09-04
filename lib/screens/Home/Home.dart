import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:bill_splitter/widgets/add_bill_form.dart';
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
    void showBillForm(){
      showModalBottomSheet(context: context,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(8)),
            side: BorderSide(
              color: Colors.amber,
              width: 2
            )
          )
          ,builder: (context) {
        return SingleChildScrollView(
          child: SafeArea(
            top: false,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: AddBillForm(),
            ),
          ),
        );
      });
    }
    return loading? Loading(): Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Bill Splitter"),
        actions: [
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
          showBillForm();
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
