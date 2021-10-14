import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final msg;
  const ErrorMessage({Key? key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "$msg",
        style: TextStyle(fontSize: 11, color: primary),
        textAlign: TextAlign.center,
      ),
    );
  }
}
