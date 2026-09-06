import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/screens/Home/bill_details.dart';
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
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => BillDetails(
                bill: bill
            )
        )
        );
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
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(3)
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        bill.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 12),
              Expanded(
                flex: 3,
                  child: Center(
                    child: Text(
                      "\$${bill.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
              ),
              SizedBox(height: 12),
              Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(3)
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.amber,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                                "${bill.participants.length} Participants",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 3
                          ),
                          child: Divider(
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 4),
                            Text(
                                "${bill.createdAt.year}/${bill.createdAt.month}/${bill.createdAt.day}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      )
    );
  }
}
