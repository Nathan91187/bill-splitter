import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/providers/invite_provider.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:bill_splitter/widgets/invite_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteList extends StatelessWidget {
  const InviteList({super.key});
  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          "Invites",
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: Consumer<InviteProvider>(builder: (context,inviteProvider,child){
        final inviteList = inviteProvider.inviteList;
        if(inviteList.isEmpty) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mark_email_read_outlined,
                  color: Colors.grey.withOpacity(0.25),
                  size: 60,
                ),
                SizedBox(width: 10,),
                Text(
                  "No Invites to Show",
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.25),
                      fontSize: 20
                  ),
                )
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
              itemBuilder: (context,index) async{
                final senderName = await userService.findUserById(inviteList[index].senderID)
                return InviteCard(senderName: userService.findUserById(uid), groupName: groupName, onAccept: onAccept, onReject: onReject)
              }),
        );
      }),
    );
  }
}
