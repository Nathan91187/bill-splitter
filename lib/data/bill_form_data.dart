import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/models/expense.dart';
import 'package:bill_splitter/models/participant.dart';
import 'package:flutter/material.dart';

class BillFormData {
  TextEditingController titleController = TextEditingController();
  List<Map<String, TextEditingController>> expenseFields = [
    {'name': TextEditingController(),
      'price' : TextEditingController(),
      'quantity' : TextEditingController(),
    }
  ];
  List <TextEditingController> participants = [TextEditingController()];
  void addParticipantField(){
      participants.add(
          TextEditingController()
      );
  }
  void removeParticipantField(int index){
    if(participants.length > 1){
      participants.removeAt(index);
    }
  }
  void addExpenseField(){
      expenseFields.add({
        'name': TextEditingController(),
        'price' : TextEditingController(),
        'quantity' : TextEditingController()
    });
  }
  void removeExpenseField(int index){
    if(expenseFields.length > 1){
    expenseFields.removeAt(index);}
  }
  Bill createBill(String uid){
    List <Expense> expenses = [];
    List <Participant> participantList = [];
    double totalAmount = 0;
    for(final expense in expenseFields){
      final price = double.parse(expense['price']!.text);
      final quantity = int.parse(expense['quantity']!.text);
      expenses.add(Expense(price: price, description: expense['name']!.text, quantity: quantity));
      totalAmount +=  price * quantity;
    }
    for(final participant in participants){
      participantList.add(Participant(name: participant.text));
    }
    return Bill(
        billID: "not assigned so far", createdAt: DateTime.now(), creatorID: uid, expenses: expenses, participants: participantList, title: titleController.text, totalAmount: totalAmount);

  }
  void dispose(){
    for(final expense in expenseFields){
      expense['name']?.dispose();
      expense['price']?.dispose();
      expense['quantity']?.dispose();
    }
    for(final participant in participants){
      participant.dispose();
    }
    participants.clear();
  }
}