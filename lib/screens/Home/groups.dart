
import 'package:bill_splitter/providers/group_provider.dart';
import 'package:bill_splitter/widgets/group_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Groups extends StatelessWidget {
  const Groups({super.key});

  @override
  Widget build(BuildContext context) {
    final groupList = Provider.of<GroupProvider>(context).groupList;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          "Groups",
          style: TextStyle(
              fontWeight: FontWeight.w600
          ),
        ),
            ),
      body: groupList.isEmpty ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              color: Colors.grey.withOpacity(0.25),
              size: 60,
            ),
            Text(
              "No Groups Yet",
              style: TextStyle(
                  color: Colors.grey.withOpacity(0.25),
                  fontSize: 20
              ),
            )
          ],
        ),
      ) : GroupList()
      );
  }
}
