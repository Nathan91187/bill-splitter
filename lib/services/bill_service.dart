import 'package:bill_splitter/models/expense.dart';
import 'package:bill_splitter/models/participant.dart';
import 'package:bill_splitter/services/group_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bill.dart';

class BillService {
  final billCollection = FirebaseFirestore.instance.collection("bills");
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String? groupId;
  Future <void> saveBill(Bill bill) async {
    final docRef = bill.billID.isEmpty ?  billCollection.doc() : billCollection.doc(bill.billID);
   await docRef.set({
     'is_group' : bill.groupID != null,
      'group_id' : bill.groupID,
      'title' : bill.title,
      'creator_id' : bill.creatorID,
      'participants' : bill.participants.map((participant){
        return {
          'name' : participant.name,
          'has_paid' : participant.hasPaid,
          'uid': participant.uid
        };
      }).toList(),
      'expenses' : bill.expenses.map((expense){
        return {
          'name' : expense.description,
          'price' : expense.price,
          'quantity' : expense.quantity
        };
      }).toList(),
      'date' : bill.createdAt,
      'total' : bill.totalAmount,
      'currency' : bill.currency,
    });
  }
  Future <void> removeBill(String billID) async{
    await billCollection.doc(billID).delete();
  }
  List<Bill> _billListFromSnapshot(QuerySnapshot snapshot){
    final bills =  snapshot.docs.map((doc){
      return Bill(
          billID: doc.id,
          groupID: doc['group_id'],
          createdAt: (doc['date'] as Timestamp).toDate(),
          creatorID: doc['creator_id'],
          expenses: (doc['expenses'] as List).map((expense) {
            return Expense(
                price: (expense['price'] as num).toDouble(),
                description: expense['name'],
                quantity: expense['quantity']);
          }).toList() ,
          participants: (doc['participants'] as List).map((participant){
            return Participant(
                name: participant['name'],
                hasPaid: participant['has_paid'],
                uid: participant['uid']
            );
          }).toList(),
          title: doc['title'],
          totalAmount: (doc['total'] as num).toDouble(),
          currency: doc['currency']
      );
    }).toList();
    bills.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return bills;
  }
  Stream <List<Bill>> get bills{
    return billCollection.where('is_group', isEqualTo: false).where('creator_id' , isEqualTo: uid).snapshots().map(_billListFromSnapshot);
  }
  Stream<List<Bill>> getGroupBills(String groupID){
    return billCollection
        .where('is_group' , isEqualTo: true)
        .where('group_id' , isEqualTo: groupID)
        .snapshots().map(_billListFromSnapshot);
  }
  }
