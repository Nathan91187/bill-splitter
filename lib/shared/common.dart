import 'package:flutter/material.dart';

final textFieldDecoration = InputDecoration(
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.black,
        width: 2
    ),
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.amber,
          width: 2
      )
  ),
  fillColor: Colors.grey,
  filled: true
);