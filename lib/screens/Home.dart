import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/screens/groups/groups.dart';
import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:bill_splitter/screens/add_bill_form.dart';
import 'package:bill_splitter/widgets/bill_widgets/bill_list.dart';
import 'package:bill_splitter/widgets/confirmation_dialog.dart';
import 'package:bill_splitter/screens/invitation/invite_list.dart';
import 'package:bill_splitter/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: Text(
            "Bill Splitter",
            style: TextStyle(
              fontWeight: FontWeight.w600
            ),
        ),
        leading: Builder(
            builder: (context) {
              return IconButton(
                  onPressed: (){
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu));

            }),
      ),
      drawer: MainDrawer(),

    body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: BillList(),
        ),
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
