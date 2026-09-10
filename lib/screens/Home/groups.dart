
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
      body:  GroupList()
      );
  }
}
