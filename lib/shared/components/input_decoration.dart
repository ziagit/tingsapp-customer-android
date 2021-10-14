import 'package:flutter/material.dart';

InputDecoration inputDecoration(context, title) {
  return InputDecoration(
    labelText: '$title',
    border: OutlineInputBorder(),
    isDense: true,
    prefixIcon: Icon(Icons.stairs_outlined),
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
