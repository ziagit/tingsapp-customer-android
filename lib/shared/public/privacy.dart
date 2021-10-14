import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter_html/flutter_html.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  String? _htmlData;
  String? _arg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Privacy Notice",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primary,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: _htmlData == null
              ? Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Loading"),
                      JumpingDotsProgressIndicator(
                        fontSize: 20.0,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Html(
                    data: _htmlData,
                  ),
                ),
        ));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _arg = ModalRoute.of(context)?.settings.arguments.toString();
      print(_arg);
      _get(_arg);
    });
  }

  _get(_arg) async {
    Api api = new Api();
    var response = await api.get('get-privacy');
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        _htmlData = jsonData['body'].toString();
      });
    }
  }
}
