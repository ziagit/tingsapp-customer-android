import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';

ButtonStyle buttonStyle(context) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(primary!),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
    ),
  );
}
