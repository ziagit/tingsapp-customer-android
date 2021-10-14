import 'package:flutter/material.dart';

InputDecoration inputDecoration2(context, title) {
  return InputDecoration(
    labelText: '$title',
    border: OutlineInputBorder(),
    isDense: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
  );
}
