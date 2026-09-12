import 'package:bill_splitter/data/error_messages.dart';
import 'package:bill_splitter/models/bill_group.dart';
import 'package:bill_splitter/screens/groups/groups.dart';
import 'package:bill_splitter/services/group_service.dart';
import 'package:bill_splitter/services/invite_service.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:bill_splitter/shared/common.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
class InviteForm extends StatefulWidget {
  final String groupID;
  const InviteForm({
    super.key,
    required this.groupID
  });

  @override
  State<InviteForm> createState() => _InviteFormState();
}

class _InviteFormState extends State<InviteForm> {
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String mainError = '';
  List<TextEditingController> controllers = [TextEditingController()];
  List <String?> errors = [null];
  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          "Invite Users",
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkey,
              child: Column(
                children: [
                  ...controllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber,),
                      ),
                      child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                validator: (val) {
                                  if(val == null || val.isEmpty){
                                    return "Email can't be empty";
                                  }
                                  final emailRegex = RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  );

                                  if (!emailRegex.hasMatch(val.trim())) {
                                    return "Enter a valid email";
                                  }
                                  return null;

                                },
                                decoration:
                                textFieldDecoration.copyWith(
                                  hintText: "Receiver Email",
                                  errorText: errors[index]
                                ),
                              ),
                            ),

                            if (index != 0)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    controllers[index].dispose();
                                    controllers.removeAt(index);
                                    errors.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.amber,
                                ),
                              ),
                          ]),
                    );
                  }
                  ),
                  SizedBox(height: 12,),
                  OutlinedButton.icon(
                    onPressed: () {
                      print('ADD RECEIVER CLICKED');

                      setState(() {
                        controllers.add(TextEditingController());
                        errors.add(null);
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.amber,
                    ),
                    label: const Text(
                      "Add Receiver ",
                      style: TextStyle(
                        color: Colors.amber,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  SizedBox(height: 28,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () async {
                        if(_formkey.currentState!.validate()){
                          final groupService = GroupService();
                          final userService = UserService();
                          final inviteService = InviteService();
                          setState(() {
                            errors = List<String?>.filled(controllers.length,null,growable: true);
                            mainError = '';
                            loading = true;
                          });
                          final List<UserModel> validUsers = [];
                          BillGroup? group;
                        try {
                          group = await groupService.findGroupByID(widget.groupID);
                        } catch (e) {
                          final error = e.toString().replaceFirst('Exception: ', '');
                          setState(() {
                            mainError = ErrorMessages().errorMessages[error]
                              ?? "Something went wrong. Please try again.";
                            loading = false;
                        });

                        return;
                        }
                          if(group == null){
                            mainError = "Group couldn't be found";
                            setState(() {
                              loading = false;
                            });
                            return;
                          }
                          for(int i = 0; i < controllers.length;i++){

                            try {
                              final user = await userService.findUserByEmail(controllers[i].text.trim());
                              if(user == null){
                                errors[i] = "User doesn't exist";
                                continue;
                              }
                              if(user.uid == FirebaseAuth.instance.currentUser!.uid){
                                errors[i] = "You can't invite yourself";
                                continue;
                              }
                              if(group.memberIDs.contains(user.uid)){
                                errors[i] = "User is already a member";
                                continue;
                              }
                                final isPending = await inviteService.hasPendingInvite(group.groupID!, user.uid);
                                if(isPending){
                                  errors[i] = "Invitation already pending";
                                  continue;
                              }
                              validUsers.add(user);
                            } on Exception catch (e) {
                              final error = e.toString().replaceFirst('Exception: ', '');
                              mainError = ErrorMessages().errorMessages[error] ?? "Something went wrong. Please try again.";
                              break;
                            }
                          }
                          if(mainError.isNotEmpty){
                            setState(() {
                              loading = false;
                            });
                            return;
                          }
                          if(errors.any((error)=> error != null)){
                            setState(() {
                              loading = false;
                            });
                            return;
                          }
                          for(UserModel validUser in validUsers){
                            await inviteService.sendInvite(group.groupID!, validUser.uid);
                          }
                          if(context.mounted){
                            Navigator.pop(context);
                          }
                        }
                      },
                      icon: Icon(
                         Icons.group_add_outlined,
                        color: Colors.black,
                      ),
                      label: Text(
                        "Invite Users",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.amber,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    mainError,
                    style: TextStyle(
                        color: Colors.red
                    ),
                  )
                ]
                )
                )
                )
                ),
    );
  }
}
