import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final title;
  const CustomTitle({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 0),
      padding: EdgeInsets.all(30),
      child: Text(
        "$title",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
