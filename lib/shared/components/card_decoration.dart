import 'package:flutter/material.dart';

Decoration cardDecoration(context) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      new BoxShadow(
        color: Colors.grey.shade200,
        offset: new Offset(0.0, 10.0),
        blurRadius: 10.0,
        spreadRadius: 1.0,
      )
    ],
  );
}
