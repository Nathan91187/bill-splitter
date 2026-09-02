import 'package:bill_splitter/models/expense.dart';
import 'package:bill_splitter/models/participant.dart';

class Bill {
  final String billID;
  final String creatorID;
  final String title;
  final String? groupID;
  final List<Expense> expenses;
  final List<Participant> participants;
  final DateTime createdAt;
  final double totalAmount;
  const Bill({
    required this.billID,
    required this.createdAt,
    required this.creatorID,
    required this.expenses,
    this.groupID,
    required this.participants,
    required this.title,
    required this.totalAmount
});
}