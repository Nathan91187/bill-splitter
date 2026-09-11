import 'package:bill_splitter/models/bill_group.dart';
import 'package:bill_splitter/providers/group_provider.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:bill_splitter/widgets/section_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/common.dart';

class CreateGroupForm extends StatefulWidget {
  final BillGroup? billGroup;
  const CreateGroupForm({
    super.key,
    this.billGroup
  });

  @override

  State<CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  TextEditingController titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final creatorID = FirebaseAuth.instance.currentUser!.uid;
  bool loading = false;
  @override
  void initState(){
    super.initState();
   if(widget.billGroup != null){
     titleController.text = widget.billGroup!.groupName;
   }
  }
  @override
  void dispose(){
    super.dispose();
    titleController.dispose();

  }
  Future<void> submitGroup() async{
    setState(() {
      loading = true;
    });
    final groupProvider = context.read<GroupProvider>();
    await groupProvider.addGroup(BillGroup(creatorID: creatorID, groupName: titleController.text, memberIDs: [creatorID]));
    if(mounted){
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
      title: widget.billGroup == null ? Text(
          "Create Group",
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
      ) : Text(
          "Edit Group",
          style: TextStyle(
          fontWeight: FontWeight.w600
      ),
      ),
      ),
    body: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 30),
        child: Column(
          children: [
            SectionHeader(icon: Icons.group_outlined, title: "Group Name"),
            const SizedBox(height: 12,),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(8),
                border: Border.all( color: Colors.amber,),
              ),
              child: TextFormField(
                controller: titleController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Group Name is required";
                  }
                  return null;
                },
                decoration: textFieldDecoration.copyWith(
                  hintText: "Group Name",
                ),
              ),
            ),
             SizedBox(height: 28,),
             SizedBox(
               width: double.infinity,
               height: 50,
               child: FilledButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitGroup();
                  }
                },
                icon: Icon(
                  widget.billGroup == null
                      ? Icons.check
                      : Icons.save_outlined,
                  color: Colors.black,
                ),
                label: Text(
                  widget.billGroup == null
                      ? "Create Group"
                      : "Save Changes",
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
          ],
        ),
      ),
    ),
    );
  }
}
