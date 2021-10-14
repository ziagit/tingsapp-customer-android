import 'package:flutter/material.dart';

hideKeboard(context, currentFocus) {
  currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
