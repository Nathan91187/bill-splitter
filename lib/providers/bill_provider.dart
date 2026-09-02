import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/models/participant.dart';
import 'package:flutter/material.dart';

class BillProvider extends ChangeNotifier{
  List <Bill> billList = [];
  void addBill(Bill bill){
    billList.add(bill);
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