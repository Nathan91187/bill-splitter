import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/widgets/bill_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillList extends StatelessWidget {
  const BillList({super.key});

  @override
  Widget build(BuildContext context) {
    final billList = Provider.of<BillProvider>(context).billList;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2
        ),
        itemCount: billList.length,
        itemBuilder: (context,index){
          return BillCard(bill: billList[index]);
        });
  }
}
