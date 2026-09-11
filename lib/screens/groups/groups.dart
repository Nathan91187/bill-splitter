
import 'package:bill_splitter/providers/group_provider.dart';
import 'package:bill_splitter/screens/groups/create_group_form.dart';
import 'package:bill_splitter/widgets/group_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'create_group_form.dart';

class Groups extends StatelessWidget {
  const Groups({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,)),
        title: Text(
          "Groups",
          style: TextStyle(
              fontWeight: FontWeight.w600
          ),
        ),
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 15),
        child: GroupList(),
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
              builder: (context) => CreateGroupForm()
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
