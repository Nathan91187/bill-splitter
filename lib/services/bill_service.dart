import 'package:bill_splitter/models/expense.dart';
import 'package:bill_splitter/models/participant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bill.dart';

class BillService {
  final billCollection = FirebaseFirestore.instance.collection("bills");
  Future <void> saveBill(Bill bill) async {
    final docRef = bill.billID.isEmpty ?  billCollection.doc() : billCollection.doc(bill.billID);
   await docRef.set({
      'title' : bill.title,
      'creator_id' : bill.creatorID,
      'participants' : bill.participants.map((participant){
        return {
          'name' : participant.name
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
    return snapshot.docs.map((doc){
      return Bill(
          billID: doc.id,
          createdAt: (doc['date'] as Timestamp).toDate(),
          creatorID: doc['creator_id'],
          expenses: (doc['expenses'] as List).map((expense) {
            return Expense(
                price: expense['price'],
                description: expense['name'],
                quantity: expense['quantity']);
          }).toList() ,
          participants: (doc['participants'] as List).map((participant){
            return Participant(
                name: participant['name']);
          }).toList(),
          title: doc['title'],
          totalAmount: doc['total'],
          currency: doc['currency']
      );
    }).toList();
  }
  Stream <List<Bill>> get bills{
    return billCollection.snapshots().map(_billListFromSnapshot);

  }
  }
