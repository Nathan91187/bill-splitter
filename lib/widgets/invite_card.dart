import 'package:bill_splitter/models/bill_group.dart';
import 'package:bill_splitter/models/group_invite.dart';
import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/providers/invite_provider.dart';
import 'package:bill_splitter/services/group_service.dart';
import 'package:bill_splitter/services/invite_service.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteCard extends StatefulWidget {
  final GroupInvite groupInvite;

  const InviteCard({
    super.key,
    required this.groupInvite

  });

  @override
  State<InviteCard> createState() => _InviteCardState();
}

class _InviteCardState extends State<InviteCard> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final inviteService = InviteService();
    final inviteProvider = Provider.of<InviteProvider>(context);
    return Card(
      color: const Color(0xFF111111),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.amber, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.group_outlined, color: Colors.amber),
                const SizedBox(width: 10),
                const Text(
                  'Group Invitation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            FutureBuilder<UserModel?>(
                future: UserService().findUserById(widget.groupInvite.senderID),
                builder: (context,user){
                  if (user.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    );
                  }
                  if(user.hasError){
                    return const Text(
                      "Failed to load user",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    );
                  }
                  final senderName = user.data?.displayName ?? "An anonymous user";
                  return Text(
                    '$senderName invited you to join',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  );
                }),

            const SizedBox(height: 4),

            FutureBuilder<BillGroup?>(
                future: GroupService().findGroupByID(widget.groupInvite.groupID),
                builder: (context,group){
                  if (group.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    );
                  }
                  if(group.hasError){
                    return const Text(
                      "Failed to load group",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    );
                  }
                  final groupName = group.data!.groupName;
                  return Text(
                    groupName,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: () async{
                    await inviteService.rejectInvitation(widget.groupInvite.inviteID!);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Reject'),
                ),

                const SizedBox(width: 10),

                FilledButton(
                  onPressed: () async{
                      try {
                        await inviteProvider.acceptInvitation(widget.groupInvite);
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Joined group successfully'),
                            ),
                          );
                        }
                      } catch (e) {
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to join group'),
                            ),
                          );
                        }
                      }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Accept',
                          style: TextStyle(
                                fontWeight: FontWeight.w600
    ),
    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
