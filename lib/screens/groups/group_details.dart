import 'package:bill_splitter/models/bill_group.dart';
import 'package:flutter/material.dart';

class GroupDetails extends StatelessWidget {
  final BillGroup billGroup;
  const GroupDetails({
    super.key,
    required this.billGroup
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
            billGroup.groupName,
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),

      ),
    );
  }
}
