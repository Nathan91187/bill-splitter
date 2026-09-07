import 'package:bill_splitter/data/bill_form_data.dart';
import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final BillFormData billFormData;
  const CurrencyDropdown({
    super.key,
    required this.billFormData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        border: Border.all(
          color: Colors.amber,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: billFormData.currency,
        decoration: const InputDecoration(
          hintText: "Currency",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
        dropdownColor: Colors.amber,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        items: const [
          DropdownMenuItem(
            value: 'ETB',
            child: Text('Ethiopian Birr (ETB)'),
          ),
          DropdownMenuItem(
            value: 'USD',
            child: Text('US Dollar (USD)'),
          ),
          DropdownMenuItem(
            value: 'EUR',
            child: Text('Euro (EUR)'),
          ),
          DropdownMenuItem(
            value: 'GBP',
            child: Text('British Pound (GBP)'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            billFormData.currency = value;
          }
        },
      ),
    );
  }
}
