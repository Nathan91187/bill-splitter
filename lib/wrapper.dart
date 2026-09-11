import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/providers/group_provider.dart';
import 'package:bill_splitter/screens/Home.dart';
import 'package:bill_splitter/screens/groups/groups.dart';
import 'package:bill_splitter/screens/authentication/display_name_form.dart';
import 'package:bill_splitter/screens/authentication/authenticate.dart';
import 'package:bill_splitter/services/bill_service.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:bill_splitter/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/bill.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if(user == null){
      return Authenticate();
    }
    return FutureBuilder<UserModel?>(
      future:  UserService().findUserById(FirebaseAuth.instance.currentUser!.uid),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Loading();
        }
        final namedUser = snapshot.data;
        if(namedUser == null){
          return const DisplayNameForm();
        }
        return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => BillProvider(),

              ),
              ChangeNotifierProvider(
                  create: (_) => GroupProvider())
            ],
            child: const MaterialApp(
              home: Home(),
            ));
      },
    );
  }
}
