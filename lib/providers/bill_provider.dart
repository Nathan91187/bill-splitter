import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/models/participant.dart';
import 'package:bill_splitter/services/auth.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class BillProvider extends ChangeNotifier{
  final uid = AuthService().auth.currentUser!.uid;
  List <Expense> expenses = [
    Expense(price: 30, description: "x", quantity: 3),
    Expense(price: 20, description: "y", quantity: 4),
    Expense(price: 40, description: "z", quantity: 4) ];
  List <Participant> participants = [
    Participant(name: "nate"),
    Participant(name: "Nathan"),
    Participant(name: "Trobbio") ];
  List <Bill> billList = [
    Bill(billID: "To be Specfied",
  createdAt: DateTime.now(),
  creatorID: "uid",
  expenses:[
  Expense(price: 30, description: "x", quantity: 3),
  Expense(price: 20, description: "y", quantity: 4),
  Expense(price: 40, description: "z", quantity: 4)],
  participants: [
  Participant(name: "nate"),
  Participant(name: "Nathan"),
  Participant(name: "Trobbio"),
  ],
  title: "Lunch",
  totalAmount: 120)];

  void addBill(Bill bill){
    billList.add(bill);
    notifyListeners();
  }
  void updateBill(Bill bill){
    final index = billList.indexWhere((currentBill) => bill.billID == currentBill.billID);
    if(index != -1){
      billList[index] = bill;
    }
    notifyListeners();
  }
  void removeBill(String billID){
    Bill billToBeRemoved = billList.firstWhere((val) => val.billID == billID);
    billList.remove(billToBeRemoved);
    notifyListeners();
  }
  void removeParticipant(Participant participant, String billID){
    Bill thisBill = billList.firstWhere((val) => val.billID == billID);
    thisBill.participants.remove(participant);
    notifyListeners();
  }
}