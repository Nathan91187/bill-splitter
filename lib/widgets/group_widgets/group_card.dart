import 'package:bill_splitter/models/bill_group.dart';
import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/screens/groups/group_details.dart';
import 'package:bill_splitter/services/bill_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupCard extends StatelessWidget {
  final BillGroup billGroup;

  const GroupCard({super.key, required this.billGroup});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            BillService().groupId = billGroup.groupID;

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetails(groupID: billGroup.groupID!),
              ),
            );

            if (context.mounted) {
              context.read<BillProvider>().listenStandaloneBills();
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.group, color: Colors.amber, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    billGroup.groupName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
