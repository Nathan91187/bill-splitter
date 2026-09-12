import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthService{
  final auth = FirebaseAuth.instance;
  // UserModel? _userFromFirebaseUser(User? user){
  //   if(user == null){
  //     return null;
  //   }
  //   return UserModel(uid: user.uid);
  // }
  Stream <User?> get user{
    return auth.authStateChanges();
  }
  Future signInWithEmailAndPassword(String email, String password) async{
      await auth.signInWithEmailAndPassword(email: email.toLowerCase().trim(), password: password);
    }
  Future register(String email, String password) async{
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }
  Future signOut() async{
    try{
      await auth.signOut();
    }
    catch(e){
      return e.toString();
    }
  }
}