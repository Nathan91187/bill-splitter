import 'package:bill_splitter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> saveUser(UserModel user) async {
    await userCollection.doc(user.uid).set({
      'display_name' : user.displayName,
      'email' : user.email
    });
  }
  Future<UserModel?> findUserById(String uid) async{
    final doc = await userCollection.doc(uid).get();
    if(!doc.exists){
      return null;
    }
    return UserModel(uid: doc.id, displayName: doc['display_name'], email: doc['email']);
  }
  Future<UserModel?> findUserByEmail(String email) async{
    final snapshot = await userCollection.where('email' , isEqualTo: email).get();
    if(snapshot.docs.isEmpty){
      return null;
    }
    final doc = snapshot.docs.first;
    return UserModel(uid: doc.id, displayName: doc['display_name'], email: doc['email']);
  }
  Future<UserModel>findUserByIds
}