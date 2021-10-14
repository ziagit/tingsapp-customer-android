import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/api.dart';
import 'package:flutter_html/flutter_html.dart';

class HowWorks extends StatefulWidget {
  @override
  _HowWorksState createState() => _HowWorksState();
}

class _HowWorksState extends State<HowWorks> {
  String? _htmlData;
  String? _arg;
  String _title = "How it works";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$_title",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
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
                : Html(
                    data: _htmlData,
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _arg = ModalRoute.of(context)?.settings.arguments.toString();
      _get(_arg);
    });
  }

  _get(_arg) async {
    Api api = new Api();
    var response = await api.get('get-faq');
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        _htmlData = jsonData['body'].toString();
      });
    }
  }
}
