import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bill.dart';

class BillService {
  final billCollection = FirebaseFirestore.instance.collection("bills");
  Future <void> addBill(Bill bill) async {
   await billCollection.add({
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
    });
  }
}