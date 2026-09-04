import 'package:bill_splitter/data/bill_form_data.dart';
import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/shared/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bill.dart';
class AddBillForm extends StatefulWidget {
  const AddBillForm({super.key});

  @override
  State<AddBillForm> createState() => _AddBillFormState();
}

class _AddBillFormState extends State<AddBillForm> {
  final _formkey = GlobalKey<FormState>();
   final billFormData = BillFormData();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void dispose() {
    billFormData.dispose();
    super.dispose();
  }
  void submitBill(){
    final billProvider = context.read<BillProvider>();
    billProvider.addBill(billFormData.createBill(uid));
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    final billProvider = Provider.of<BillProvider>(context);
    return Form(
        key: _formkey,
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Text(
                "Add Bill Details",
                style: TextStyle(
                    fontSize: 18,
                  color: Colors.white38
                ),
              ),
              TextFormField(
                validator: (val) {
                  if(val == null || val.trim().isEmpty){
                    return "Enter Bill Name";
                  }
                  return null;
                },
                decoration: textFieldDecoration.copyWith(hintText: "Bill Name"),
                controller: billFormData.titleController,
              ),
              SizedBox(height: 20),
              Text(
                "Items",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white38
                ),
              ),
              ...billFormData.expenseFields.asMap().entries.map((entry) {
                final index = entry.key;
                final expense = entry.value;
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        validator: (val) {
                          if(val == null || val.trim().isEmpty){
                            return "Enter Item Name";
                          }
                          return null;
                        },
                        controller: expense['name'],
                        decoration: textFieldDecoration.copyWith(
                          hintText: "Item Name",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        validator: (val){
                          if(val == null || val.trim().isEmpty){
                            return "Enter Price";
                          }
                          final price = double.tryParse(val);
                          if(price == null || price <= 0){
                            return "Invalid Price";
                          }
                          return null;
                        },
                        controller: expense['price'],
                        decoration: textFieldDecoration.copyWith(
                          hintText: "Price",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        validator: (val){
                          if(val == null || val.trim().isEmpty){
                            return "Enter Quantity";
                          }
                          final quantity = int.tryParse(val);
                          if(quantity == null || quantity <= 0){
                            return "Invalid Quantity";
                          }
                          return null;
                        },
                        controller: expense['quantity'],
                        decoration: textFieldDecoration.copyWith(
                          hintText: "Quantity",
                        ),
                      ),
                    ),
                    if(index != 0 )
                          Expanded(
                        flex: 1,
                        child: IconButton(
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                billFormData.removeExpenseField(index);
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.amber,
                            ))
                    )
                  ],
                );
              }),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: (){
                  setState(() {
                    billFormData.addExpenseField();
                  });
                },
                label: Text(
                    "Add item",
                    style: TextStyle(
                        color: Colors.black
                    )),
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    elevation: 0
                ),
              ),
              SizedBox(height: 20),
                Text(
                "Participants",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white38
                ),
              ),
    ...billFormData.participants.asMap().entries.map((entry){
              final index = entry.key;
              final participant = entry.value;
              return Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                                validator: (val){
                                  if(val == null || val.trim().isEmpty){
                                    return "Enter Participant Name";
                                  }
                                  return null;
                                },
                                controller: participant,
                                decoration: textFieldDecoration.copyWith(hintText: "Participant Name"),
                              ),
                  ),
                  if(index != 0)
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                billFormData.removeParticipantField(index);
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.amber,
                            ))
                    )
                ],
              );}),
              SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: (){
                          setState(() {
                            billFormData.addParticipantField();
                          });
    },
                        label: Text(
                            "Add Participant",
                            style: TextStyle(
                                color: Colors.black
                            )),
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        style: ElevatedButton.styleFrom(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(radius)
                          // ),
                            backgroundColor: Colors.amber,
                            elevation: 0
                        ),
                  ),
              SizedBox(height: 20),
              Align(
                alignment: AlignmentGeometry.bottomRight,
                child: ElevatedButton(
                  onPressed: (){
                    if(_formkey.currentState!.validate()){
                      submitBill();
                      for(Bill bill in billProvider.billList){
                        print(bill);
                      }
                  }},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      elevation: 0
                  ),
                  child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.black
                      ),
                  ),
                ),
              ),
                ],
          ),
        ),
    );
  }
}
