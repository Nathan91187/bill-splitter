import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/screens/groups/groups.dart';
import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:bill_splitter/screens/add_bill_form.dart';
import 'package:bill_splitter/widgets/bill_list.dart';
import 'package:bill_splitter/widgets/confirmation_dialog.dart';
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
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 100,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                    "Bill Splitter",
                  style: TextStyle(
                      color: Colors.amber,
                    fontWeight: FontWeight.w600
                  ),
                )),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.group, color: Colors.amber, size: 20),
              ),
              title: Text(
                  "Groups",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Groups()));
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mail_outlined, color: Colors.amber, size: 20),
              ),
              title: Text(
                "Invites",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit, color: Colors.amber, size: 20),
              ),
              title: Text(
                "Edit Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout, color: Colors.amber, size: 20),
              ),
              title: Text(
                  "Logout",
                style: TextStyle(
                    color: Colors.white,
                  fontWeight: FontWeight.w600
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                ConfirmationDialog().showConfirmationDialog(
                    context,
                    "Logout?",
                    "Are you sure you want to logout",
                    "Cancel",
                    "Logout",
                    () => AuthService().signOut(),
                    Icons.logout);
              },
            )
          ],
        ),
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
