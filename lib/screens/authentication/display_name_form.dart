
import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/screens/Home.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:bill_splitter/widgets/section_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/common.dart';

class DisplayNameForm extends StatefulWidget {
  const DisplayNameForm({
    super.key,
  });

  @override
  State<DisplayNameForm> createState() => _DisplayNameFormState();
}

class _DisplayNameFormState extends State<DisplayNameForm> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final currUser = FirebaseAuth.instance.currentUser!;
  TextEditingController nameController = TextEditingController();
  Future<void> submitUser(UserModel userModel)async{
    setState(() {
      loading = true;
    });
    await UserService().saveUser(userModel);

    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const MaterialApp(
            home: Home(),
          )));
    }
  }
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          "Complete Your Profile",
          style: TextStyle(
              fontWeight: FontWeight.w600
          ),
        )),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 30),
          child: Column(
            children: [
              SectionHeader(icon: Icons.person, title: "User Name"),
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
                  controller: nameController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "User Name is required";
                    }
                    return null;
                  },
                  decoration: textFieldDecoration.copyWith(
                    hintText: "User Name",
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
                      submitUser(UserModel(uid: currUser.uid, displayName: nameController.text.trim(), email: currUser.email!));
                    }
                  },
                  icon: Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                  label: Text(
                    "Continue",
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
