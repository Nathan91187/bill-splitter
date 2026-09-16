import 'package:flutter/material.dart';
const TextStyle textFieldTextStyle = TextStyle(
  color: Colors.white
) ;
final InputDecoration textFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.grey.shade900,
  hintStyle: TextStyle(
    color: Colors.grey.shade600,
  ),
  labelStyle: TextStyle(
    color: Colors.grey.shade500,
  ),
  prefixIconColor: Colors.amber,

  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  ),

  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.amber,
    ),
  ),

  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.red,
    ),
  ),

  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.red,
    ),
  ),

  contentPadding: const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 14,
  ),
);