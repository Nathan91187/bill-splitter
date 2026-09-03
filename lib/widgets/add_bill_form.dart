
import 'package:bill_splitter/data/bill_form_data.dart';
import 'package:bill_splitter/shared/common.dart';
import 'package:flutter/material.dart';
class AddBillForm extends StatefulWidget {
  const AddBillForm({super.key});

  @override
  State<AddBillForm> createState() => _AddBillFormState();
}

class _AddBillFormState extends State<AddBillForm> {
  final _formkey = GlobalKey<FormState>();
   final billFormData = BillFormData();
  @override
  void dispose() {
    billFormData.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
              ...billFormData.expenseFields.map((expense) {
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: expense['name'],
                        decoration: textFieldDecoration.copyWith(
                          hintText: "Item Name",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: expense['price'],
                        decoration: textFieldDecoration.copyWith(
                          hintText: "Price",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: expense['amount'],
                        decoration: textFieldDecoration.copyWith(
                          hintText: "Amount",
                        ),
                      ),
                    ),
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
    ...billFormData.participants.map((participant){
              return TextFormField(
                          controller: participant,
                          decoration: textFieldDecoration.copyWith(hintText: "Participant Name"),
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

                    for(final participant in billFormData.participants ){
                      print(participant.text);
                    }
                    print(billFormData.titleController.text);
                  },
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
