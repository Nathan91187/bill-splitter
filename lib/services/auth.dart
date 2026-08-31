import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthService{
  final auth = FirebaseAuth.instance;
  Future signInAnon() async{
    try {
      final result = await auth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  UserModel? _userFromFirebaseUser(User? user){
    if(user == null){
      return null;
    }
    return UserModel(uid: user.uid);
  }
  Stream <UserModel?> get user{
    return auth.authStateChanges().map(_userFromFirebaseUser);
  }
  Future signInWithEmailAndPassword(String email, String password) async{
    try {
      final result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
    }
  Future register(String email, String password) async{
    try{
     final result = await auth.createUserWithEmailAndPassword(email: email, password: password);
     return _userFromFirebaseUser(result.user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
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