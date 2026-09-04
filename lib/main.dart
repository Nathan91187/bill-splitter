import 'package:bill_splitter/firebase_options.dart';
import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/widgets/add_bill_form.dart';
import 'package:bill_splitter/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future <void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const BillSplitter());
}
class BillSplitter extends StatelessWidget {
  const BillSplitter({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black38,
        ).copyWith(
            primary: Colors.grey,
            secondary: Colors.amber
        )
    );
    return MultiProvider(
      providers: [
        StreamProvider<UserModel?>.value(
          value: AuthService().user,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (context) => BillProvider(),
        ),
      ],
      child: MaterialApp(
        routes: {
          'edit_bill' : (context) => AddBillForm()
        },
        home: Wrapper(),
      ),
    );
}
}
