import 'package:bill_splitter/data/participant_field.dart';
import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/models/expense.dart';
import 'package:bill_splitter/models/participant.dart';
import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BillFormData {
  String currency = "ETB";
  TextEditingController titleController = TextEditingController();
  Set<UserModel> selectedMembers = {};
  UserModel? currUser;
  List<Map<String, TextEditingController>> expenseFields = [
    {'name': TextEditingController(),
      'price' : TextEditingController(),
      'quantity' : TextEditingController(),
    }
  ];
  List <ParticipantField> participants = [ParticipantField(
      textEditingController: TextEditingController(),
  )];

  Future<void> fromBill(Bill bill, String? groupID) async {
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
    if (groupID == null) {
      participants = bill.participants.map((participant) {
        return ParticipantField(
            textEditingController: TextEditingController(
              text: participant.name
            ),
          hasPaid: participant.hasPaid
        );
      }).toList();
    }
    else{
      final users = await Future.wait(
          bill.participants.map((participant) => UserService().findUserById(participant.uid!)
      ));
      selectedMembers = users.whereType<UserModel>().toSet();
    }
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
  Bill createBill(String uid, Bill? bill, String? groupId){
    List <Expense> expenses = [];
    double totalAmount = 0;
    for(final expense in expenseFields){
      final price = double.parse(expense['price']!.text);
      final quantity = int.parse(expense['quantity']!.text);
      expenses.add(Expense(price: price, description: expense['name']!.text, quantity: quantity));
      totalAmount +=  price * quantity;
    }
    List<Participant> participantList = [];
    if (groupId == null) {
      if(bill == null) {
        participantList.add(Participant(name: "You", hasPaid: false));
      }
      for(final participant in participants){
        participantList.add(Participant(name: participant.textEditingController.text,hasPaid: participant.hasPaid));
      }
    }
    else {
        if(bill == null){
          participantList.add(Participant(
              name: currUser!.displayName,
              hasPaid: false,
              uid: currUser!.uid
          ));
        }
      for(final selected in selectedMembers){
        participantList.add(Participant(name: selected.displayName, hasPaid: false, uid: selected.uid));
      }
    }
    return Bill(
      groupID: groupId,
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