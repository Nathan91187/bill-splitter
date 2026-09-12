import 'package:bill_splitter/models/group_invite.dart';
import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/services/group_service.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InviteService {
  final inviteCollection = FirebaseFirestore.instance.collection('invites');
  final groupService = GroupService();
  Future <void> sendInvite(String groupId, String receiverID)async{
    await inviteCollection.doc().set(
      {
      'group_id' : groupId,
      'sender_id' : FirebaseAuth.instance.currentUser!.uid,
      'status' : "pending",
        'receiver_id' : receiverID
      }
    );
  }
  Future<bool> hasPendingInvite(String groupID, String receiverID)async{
    try {
      final docRef = await inviteCollection
          .where('group_id' , isEqualTo: groupID)
          .where('receiver_id',isEqualTo: receiverID)
          .where('status' ,isEqualTo: "pending").get(GetOptions(source: Source.server));
      return docRef.docs.isNotEmpty;
    }on FirebaseException catch (e) {
      throw Exception(e.code);
    }

  }
  List<GroupInvite> _invitesFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((invite){
      return GroupInvite(
        inviteID: invite.id,
          groupID: invite['group_id'],
          senderID: invite['sender_id'],
          receiverID: invite['receiver_id'],
          status: invite['status']);
    }).toList();

  }
  Stream<List<GroupInvite>> get pendingInvites{
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return inviteCollection
        .where('receiver_id' , isEqualTo: uid)
        .where('status',isEqualTo: "pending")
        .snapshots().map(_invitesFromSnapshot);
  }
  Future<void> acceptInvitation(String inviteId)async{
    await FirebaseFirestore.instance.runTransaction((transaction) async{
      final docRef = inviteCollection.doc(inviteId);
      final invite = await transaction.get(docRef);
      if(!invite.exists){
        throw Exception('not-found');
      }
      final groupID = invite['group_id'];
      final receiverID = invite['receiver_id'];
      final groupRef = GroupService().groupCollection.doc(groupID);
      transaction.update(groupRef, {
        'member_ids': FieldValue.arrayUnion([receiverID])
      });
      transaction.update(docRef, {
        'status' : 'accepted'
      });
    });
  }
  Future<void>rejectInvitation (String inviteID) async{

    try {
      await inviteCollection.doc(inviteID).update({
        'status' : 'rejected'
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }
}