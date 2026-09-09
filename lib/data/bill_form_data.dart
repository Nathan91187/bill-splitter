import 'package:bill_splitter/data/participant_field.dart';
import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/models/expense.dart';
import 'package:bill_splitter/models/participant.dart';
import 'package:flutter/material.dart';

class BillFormData {
  String currency = "ETB";
  TextEditingController titleController = TextEditingController();
  List<Map<String, TextEditingController>> expenseFields = [
    {'name': TextEditingController(),
      'price' : TextEditingController(),
      'quantity' : TextEditingController(),
    }
  ];
  List <ParticipantField> participants = [ParticipantField(
      textEditingController: TextEditingController(),
  )];

  void fromBill(Bill bill){
    currency = bill.currency;
    titleController.text = bill.title;
    expenseFields = bill.expenses.map((expense) {
      return {
        'name' : TextEditingController(
          text: expense.description
        ),
        'price' : TextEditingController(
          text: expense.price.toString()
        ),
        'quantity' : TextEditingController(
          text: expense.quantity.toString()
        )
      };
    }
    ).toList();
    participants = bill.participants.map((participant) {
      return ParticipantField(
          textEditingController: TextEditingController(
            text: participant.name
          ),
        hasPaid: participant.hasPaid
      );
    }).toList();
  }
  void addParticipantField(){
      participants.add(
          ParticipantField(
              textEditingController: TextEditingController(),
          )
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
  void toggleHasPaid(int index){
    participants[index].hasPaid = !participants[index].hasPaid;
  }
  Bill createBill(String uid, Bill? bill){
    List <Expense> expenses = [];
    List <Participant> participantList = bill == null ? [
      Participant(name: "You", hasPaid: false)
    ] : [];
    double totalAmount = 0;
    for(final expense in expenseFields){
      final price = double.parse(expense['price']!.text);
      final quantity = int.parse(expense['quantity']!.text);
      expenses.add(Expense(price: price, description: expense['name']!.text, quantity: quantity));
      totalAmount +=  price * quantity;
    }
    for(final participant in participants){
      participantList.add(Participant(name: participant.textEditingController.text,hasPaid: participant.hasPaid));
    }
    return Bill(
        billID: bill == null ? "" : bill.billID,
        createdAt: bill == null ? DateTime.now() : bill.createdAt,
        creatorID: uid,
        expenses: expenses,
        participants: participantList,
        title: titleController.text,
        totalAmount: totalAmount,
      currency: currency
    );

  }

  void dispose(){
    for(final expense in expenseFields){
      expense['name']?.dispose();
      expense['price']?.dispose();
      expense['quantity']?.dispose();
    }
    for(final participant in participants){
      participant.textEditingController.dispose();
    }
    participants.clear();
  }
}