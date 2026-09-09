import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/screens/Home/groups.dart';
import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:bill_splitter/screens/Home/add_bill_form.dart';
import 'package:bill_splitter/widgets/bill_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
void confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.amber, width: 1.5),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.amber),
            SizedBox(width: 10),
            Text(
              "Logout?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to logout",
          style: TextStyle(color: Colors.white70, height: 1.4),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(
                backgroundColor: Colors.grey
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              AuthService().signOut();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );
}
class _HomeState extends State<Home> {
  final auth = AuthService();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final billList = Provider.of<BillProvider>(context).billList;
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
                    color: Colors.amber,
                    fontWeight: FontWeight.w600
                  ),
              ),
              onTap: (){
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
                child: Icon(Icons.logout, color: Colors.amber, size: 20),
              ),
              title: Text(
                  "Logout",
                style: TextStyle(
                    color: Colors.amber,
                  fontWeight: FontWeight.w600
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                confirmLogout(context);
              },
            )
          ],
        ),
      ),
      body: billList.isEmpty ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              color: Colors.grey.withOpacity(0.25),
              size: 60,
            ),
            Text(
                "No Bills to Show",
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.25),
                  fontSize: 20
                ),
            )
          ],
        ),
      ) : Container(
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
