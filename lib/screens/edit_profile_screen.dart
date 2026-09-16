import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:bill_splitter/shared/common.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final userService = UserService();
  bool loading = false;
  UserModel? user;
  Future<void> loadUser() async{
    final result = await userService.findUserById(uid);
    if(!mounted) return;
    setState(() {
      user = result;
      nameController.text = result?.displayName ?? '';
      emailController.text = result?.email ?? '';
    });
  }
  Future<void> saveChanges() async {
    if(!_formKey.currentState!.validate()) return;
    setState(() {
      loading = true;
    });
    try {
      await userService.saveUser(
        UserModel(uid: uid, displayName: nameController.text, email: user!.email)
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
        ),
      );
    }
  }
  @override
  void initState(){
    super.initState();
  loadUser();
  }
  @override
  Widget build(BuildContext context) {

    return user == null ? const Loading() : Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.amber,
                    child: const Icon(
                      Icons.person,
                      size: 42,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }

                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }

                      return null;
                    },
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.amber,
                  decoration: textFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.person_outline,color: Colors.amber,),
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600
                    ),
                    hintText: "Enter your name"
                  )
                ),

                const SizedBox(height: 24),

                const Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: emailController,
                  enabled: false,
                  style: TextStyle(color: Colors.grey.shade500),
                  decoration: textFieldDecoration.copyWith(
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: Colors.grey.shade600,
                    )
                  )
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: loading ? null : saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.amber.shade700,
                      disabledForegroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: loading
                        ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Saving...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                        : const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
