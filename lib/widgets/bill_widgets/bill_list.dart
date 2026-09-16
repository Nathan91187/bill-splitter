import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/widgets/bill_widgets/bill_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillList extends StatefulWidget {
  final String? groupId;
  const BillList({
    this.groupId,
    super.key});

  @override
  State<BillList> createState() => _BillListState();
}
class _BillListState extends State<BillList> {
  @override
  void initState(){
    super.initState();
    if(widget.groupId == null){
      context.read<BillProvider>().listenStandaloneBills();
    }
    else{
      context.read<BillProvider>().listenGroupBills(widget.groupId!);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<BillProvider>(
        builder: (context,billProvider,child) => billProvider.billList.isEmpty? Center(
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
          shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              crossAxisSpacing: 7,
              mainAxisSpacing: 7,
            ),
            itemCount: billProvider.billList.length,
            itemBuilder: (context,index){
              return BillCard(bill: billProvider.billList[index]);
            }));
  }
}
