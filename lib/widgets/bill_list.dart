import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/widgets/bill_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillList extends StatelessWidget {
  const BillList({super.key});

  @override
  Widget build(BuildContext context) {
    final billList = Provider.of<BillProvider>(context).billList;
    return billList.isEmpty? Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: Colors.grey.withOpacity(0.25),
            size: 60,
          ),
          SizedBox(width: 10,),
          Text(
            "No Bills to Show",
            style: TextStyle(
                color: Colors.grey.withOpacity(0.25),
                fontSize: 20
            ),
          )
        ],
      ),
    ) : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2
        ),
        itemCount: billList.length,
        itemBuilder: (context,index){
          return BillCard(bill: billList[index]);
        });
  }
}
