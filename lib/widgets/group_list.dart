import 'package:bill_splitter/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class GroupList extends StatelessWidget {
  const GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    final groupList = Provider.of<GroupProvider>(context).groupList;
    return groupList.isEmpty ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.groups_outlined,
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
    ) : ,
  }
}
