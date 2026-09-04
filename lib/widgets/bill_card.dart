import 'package:bill_splitter/models/bill.dart';
import 'package:flutter/material.dart';
class BillCard extends StatelessWidget {
  final Bill bill;
  const BillCard({
    super.key,
    required this.bill
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, 'routeName');
      },
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(
            color: Colors.amber,
            width: 2
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        bill.title
                      ),
                    ),
                  )),
              SizedBox(height: 20),
              Expanded(
                flex: 4,
                  child: Row(
                    children: [
                      Text(
                        "\$${bill.totalAmount.toString()}",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 30
                        ),
                      ),
                    ],
                  ),
              ),
              SizedBox(height: 20),
              Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(width: 4),
                              Text(
                                  "${bill.participants.length} Participants"
                              ),
                            ],
                          ),
                          Container(height: 1,color: Colors.black),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 4),
                              Text(
                                  "${bill.createdAt.year}/${bill.createdAt.month}/${bill.createdAt.day}"
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      )
    );
  }
}
