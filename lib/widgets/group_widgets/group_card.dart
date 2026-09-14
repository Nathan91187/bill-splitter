import 'package:bill_splitter/models/bill_group.dart';
import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/screens/groups/group_details.dart';
import 'package:bill_splitter/services/bill_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupCard extends StatelessWidget {
  final BillGroup billGroup;
  const GroupCard({
    super.key,
    required this.billGroup
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async{
            BillService().groupId = billGroup.groupID;
           await Navigator.push(context, MaterialPageRoute(
                builder: (context)=> GroupDetails(groupID: billGroup.groupID!))
            );
                if(context.mounted){
              context.read<BillProvider>().listenStandaloneBills();
            }
          },
          child: ListTile(
            minTileHeight: 50,
            contentPadding: EdgeInsets.all(5),
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                shape: BoxShape.circle
              ),
              child: Icon(
                Icons.group,
                color: Colors.amber,
                size: 30,
              ),
            ),
            title: Text(
                billGroup.groupName,
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w600
                ),
            ),
          ),
        ),
        Divider(
          color: Colors.white12,height: 1,
        )
      ],
    );
  }
}
