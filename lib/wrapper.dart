import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/screens/Home/Home.dart';
import 'package:bill_splitter/screens/authentication/authenticate.dart';
import 'package:bill_splitter/services/bill_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/bill.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if(user == null){
      return Authenticate();
    }
    return
          ChangeNotifierProvider(
            create: (_) => BillProvider(),
            child: MaterialApp(
              home: const Home(),
            ));
  }
}
