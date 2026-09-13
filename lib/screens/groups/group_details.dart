import 'package:bill_splitter/models/bill_group.dart';
import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/providers/group_provider.dart';
import 'package:bill_splitter/screens/add_bill_form.dart';
import 'package:bill_splitter/screens/groups/create_group_form.dart';
import 'package:bill_splitter/screens/invitation/invite_form.dart';
import 'package:bill_splitter/services/group_service.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:bill_splitter/widgets/confirmation_dialog.dart';
import 'package:bill_splitter/widgets/section_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupDetails extends StatefulWidget {
  final String groupID;
  const GroupDetails({
    super.key,
    required this.groupID
  });

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  bool loading = false;
  final userService = UserService();
  final currUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {

    final groupProvider = Provider.of<GroupProvider>(context);
    final billGroup = groupProvider.getGroupById(widget.groupID);
    Future<List<UserModel>> getUsers() async{
      final users = await Future.wait(
        billGroup!.memberIDs.map((memberId)=> userService.findUserById(memberId))
      );
      return users.whereType<UserModel>().toList();
    }
    if (billGroup == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          actions: [
          ],
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               const Icon(
                  Icons.group_off_outlined,
                  color: Colors.grey,
                  size: 70,
                ),
                const SizedBox(height: 16,),
                const Text(
                  textAlign: TextAlign.center,
                  "You no longer have access to this group",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return loading ? Loading() :Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
            billGroup.groupName,
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          PopupMenuButton<String>(
              color: Colors.black,
              onSelected: (value){
                if(value == 'add_bill'){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=> AddBillForm(groupID: widget.groupID,)));
                }
                else if(value == 'edit_group'){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> CreateGroupForm(billGroup: billGroup)));
                }
                else if(value == 'delete_group'){
                  ConfirmationDialog().showConfirmationDialog(context,
                      "Delete Group?",
                      "Are you sure you want to delete this group."
                          "This action can't be undone",
                      "Cancel",
                      "Delete",
                      () async {
                    setState(() {
                      loading = true;
                    });
                        await groupProvider.removeGroup(widget.groupID);
                        if(context.mounted){
                          Navigator.pop(context);
                        }
                      },
                      Icons.delete_outline);
                }
                else if(value == 'invite_users'){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          InviteForm(groupID: billGroup.groupID!)));
                }
              },
            itemBuilder: (context) =>[
              if(currUser.uid == billGroup.creatorID)
              PopupMenuItem(
                value: 'edit_group',
                child: Container(
                  color: Colors.black,
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Edit Group',
                        style: TextStyle(
                            color: Colors.amber
                        ),
                      ),
                    ],
                  ),
                ),
              ),

                 PopupMenuItem(
                   value: 'add_bill',
                   child: Container(
                     color: Colors.black,
                     child: Row(
                       children: [
                         Icon(
                             Icons.receipt_long_outlined,
                              color: Colors.amber,
                         ),
                         SizedBox(width: 10),
                         Text(
                             'Create Bill',
                              style: TextStyle(
                                color: Colors.amber
                              ),
                         ),
                       ],
                     ),
                   ),
                 ),
              PopupMenuItem(
                value: 'invite_users',
                child: Row(
                  children: [
                    Icon(
                        Icons.mail_outlined,
                        color: Colors.amber,
                    ),
                    SizedBox(width: 10),
                    Text(
                        'Invite Users',
                      style: TextStyle(
                          color: Colors.amber
                      ),),
                  ],
                ),
              ),
              if(currUser.uid == billGroup.creatorID)
              PopupMenuItem(
                value: 'delete_group',
                child: Container(
                  color: Colors.black,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Delete Group',
                        style: TextStyle(
                            color: Colors.amber
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SectionHeader(icon: Icons.receipt_long_outlined, title: "Bills"),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.grey.withOpacity(0.25),
                    size: 60,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "No Bills To Show",
                    style: TextStyle(
                        color: Colors.grey.withOpacity(0.25),
                        fontSize: 20
                    ),
                  )
                ],
              ),
              SizedBox(height: 12,),
              SectionHeader(icon: Icons.group, title: "Members"),
              SizedBox(height: 12),
              FutureBuilder<List<UserModel>>(
                  future: getUsers(),
                  builder: (context,member){
                    if(member.hasError){
                      return const Text(
                          "Failed to load members",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      );
                    }
                    final users = member.data ?? [];
                    if(member.connectionState == ConnectionState.waiting){
                      return Loading();
                    }
                    return Column(
                      children: users.map((eachMember){
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eachMember.displayName,
                                        style: const TextStyle(
                                          color: Colors.amber,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        eachMember.email,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  )),
                              if(currUser.uid == billGroup.creatorID && eachMember.uid != currUser.uid)
                                IconButton(
                                    onPressed: () => ConfirmationDialog().showConfirmationDialog(
                                      context,
                                      "Remove Member?",
                                      "Are you sure you want to remove ${eachMember.displayName} from this group?",
                                      "Cancel",
                                      "Remove",
                                          () async {
                                        await groupProvider.removeMember(
                                          billGroup.groupID!,
                                          eachMember.uid,
                                        );
                                      },
                                      Icons.person_remove_outlined,
                                    ),
                                    icon: Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.grey,
                                    )),
                              if(eachMember.uid == currUser.uid && eachMember.uid != billGroup.creatorID)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.withOpacity(0.12),
                                  ),

                                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                  child: Text(
                                    'You',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              if(eachMember.uid == billGroup.creatorID)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.amber.withOpacity(0.12),
                                  ),

                                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                  child: Text(
                                    'Creator',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList()
                    );
              })
            ],
          ),
        ),
      ),
    );
  }
}
