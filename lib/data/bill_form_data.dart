import 'dart:math';

import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/models/expense.dart';
import 'package:bill_splitter/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BillFormData {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController titleController = TextEditingController();
  List<Map<String, TextEditingController>> expenseFields = [
    {'name': TextEditingController(),
      'price' : TextEditingController(),
      'amount' : TextEditingController(),
    }
  ];
  List <TextEditingController> participants = [TextEditingController()];
  void addParticipantField(){
      participants.add(
          TextEditingController()
      );
  }
  void addExpenseField(){
      expenseFields.add({
        'name': TextEditingController(),
        'price' : TextEditingController(),
        'amount' : TextEditingController()
    });
  }
  void submitBill(){
    List <Expense> expenses = [];
    for(final expense in expenseFields){
      expenses.add(Expense(price: double.parse(expense['price']!.text), description: expense['description']!.text, quantity: int.parse(expense['quantity']!.text)));
    }
    final bill = Bill(
        billID:, createdAt: createdAt, creatorID: uid, expenses: expenses, participants: participants, title: title, totalAmount: totalAmount)
  }
  void dispose(){
    for(final expense in expenseFields){
      expense['name']?.dispose();
      expense['price']?.dispose();
      expense['amount']?.dispose();
    }
    for(final participant in participants){
      participant.dispose();
    }
    participants.clear();
  }
}