import 'package:bill_splitter/data/currency_map.dart';
import 'package:bill_splitter/models/bill.dart';
import 'package:bill_splitter/providers/bill_provider.dart';
import 'package:bill_splitter/screens/Home/add_bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillDetails extends StatelessWidget {
  final String billID;
  const BillDetails({super.key, required this.billID});
  void confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111111),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.amber, width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.amber),
              SizedBox(width: 10),
              Text(
                "Delete bill?",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this bill? "
            "This action cannot be undone.",
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.grey
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            FilledButton(
              onPressed: () {
                context.read<BillProvider>().removeBill(billID);
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                "Delete",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
  Widget sectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.amber, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final billList = Provider.of<BillProvider>(context).billList;
    Bill bill = billList.firstWhere((test) => test.billID == billID);
    final currencyMap = CurrencyMap();
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          bill.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddBillForm(bill: bill)),
              );
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
          ),
          IconButton(
            onPressed: () => confirmDelete(context),
            icon: const Icon(Icons.delete_outline, color: Colors.black),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader(icon: Icons.receipt_long_outlined, title: "Total"),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    "${currencyMap.currencyMap[bill.currency]} ${bill.totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),
              sectionHeader(icon: Icons.shopping_bag_outlined, title: "Items"),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    ...bill.expenses.asMap().entries.map((entry) {
                      final index = entry.key;
                      final expense = entry.value;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expense.description,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        "${expense.quantity} × "
                                        "${currencyMap.currencyMap[bill.currency]} ${expense.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  "${currencyMap.currencyMap[bill.currency]} ${(expense.price * expense.quantity).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (index != bill.expenses.length - 1)
                            const Divider(color: Colors.white12, height: 1),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              sectionHeader(icon: Icons.people_outline, title: "Participants"),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    ...bill.participants.asMap().entries.map((entry) {
                      final index = entry.key;
                      final participant = entry.value;
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    participant.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${currencyMap.currencyMap[bill.currency]} ${(bill.totalAmount / bill.participants.length).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          ),

                          if (index != bill.participants.length - 1)
                            const Divider(color: Colors.white12, height: 1),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
