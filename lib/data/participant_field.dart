import 'package:flutter/cupertino.dart';

class ParticipantField {
  final TextEditingController textEditingController;
  bool hasPaid;
  ParticipantField({
    required this.textEditingController,
     this.hasPaid = false
});
}