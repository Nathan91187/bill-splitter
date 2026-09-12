import 'package:bill_splitter/models/bill_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupService {
  final groupCollection = FirebaseFirestore.instance.collection('groups');
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<BillGroup> _groupListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((groups){
      return BillGroup(
          creatorID: groups['creator_id'],
          groupID: groups.id,
          groupName: groups['name'],
          memberIDs: List<String>.from(groups['member_ids']));
    }).toList();
  }
  Stream<List<BillGroup>> get groups{
    return groupCollection.where('member_ids',arrayContains: uid).snapshots().map(_groupListFromSnapshot);
  }
  Future<void> saveGroup(BillGroup group) async{
    final docRef = group.groupID == null ? groupCollection.doc() : groupCollection.doc(group.groupID!);
    return await docRef.set(
      {
        'creator_id' : uid,
        'name': group.groupName,
        'member_ids' : group.memberIDs
      }
    );
  }
  Future<void> removeGroup(String groupID) async{
     await groupCollection.doc(groupID).delete();
  }
  Future<void> removeMember(String memberId,String groupID) async{
    await groupCollection.doc(groupID).update({
     'member_ids' : FieldValue.arrayRemove([memberId])}
   );
  }
  Future<void> addMember(String groupID, String memberID)async{
    await groupCollection.doc(groupID).update({
      'member_ids' : FieldValue.arrayUnion([memberID])}
    );
  }
  Future<BillGroup?> findGroupByID(String groupID)async{
    try {
      final docRef = await groupCollection.doc(groupID).get(GetOptions(source: Source.server));
      if(!docRef.exists){
        return null;
      }
      return BillGroup(groupID: docRef.id,
          creatorID: docRef['creator_id'],
          groupName: docRef['name'],
          memberIDs: List<String>.from(docRef['member_ids']));
    } on FirebaseException catch (e) {
     throw Exception(e.code);
    }
  }
}