import 'package:bill_splitter/models/group_invite.dart';
import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InviteService {
  final inviteCollection = FirebaseFirestore.instance.collection('invites');
  Future <void> sendInvite(String groupId, String email)async{
    final receiver = await UserService().findUserByEmail(email);
    if(receiver == null){
      throw Exception('user not found');
    }
    await inviteCollection.doc().set(
      {
      'group_id' : groupId,
      'sender_id' : FirebaseAuth.instance.currentUser!.uid,
      'status' : "pending",
        'receiver_id' : receiver.uid
      }
    );
  }
}