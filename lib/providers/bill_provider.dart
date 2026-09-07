import 'dart:async';

import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/models/participant.dart';
import 'package:bill_splitter/services/auth.dart';
import 'package:bill_splitter/services/bill_service.dart';
import 'package:flutter/material.dart';
class BillProvider extends ChangeNotifier{
  final billService = BillService();
  List <Bill> billList = [];
  StreamSubscription<List<Bill>>? _billSubscription;
  BillProvider(){

    _billSubscription = billService.bills.listen((bills){
      billList = bills;
      notifyListeners();
    });
  }
  @override
  void dispose(){
    _billSubscription?.cancel();
    super.dispose();

  }


  Future <void> addBill(Bill bill) async {
    return await billService.saveBill(bill);
  }
  Future<void> removeBill(String billID) async{
   return await billService.removeBill(billID);
  }
}