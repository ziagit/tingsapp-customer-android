import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/api.dart';
import 'package:flutter_html/flutter_html.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> with SingleTickerProviderStateMixin {
  List? _customer;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Help Center",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primary,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: _customer == null
            ? Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Loading"),
                    JumpingDotsProgressIndicator(
                      fontSize: 20.0,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _customer?.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(_customer![index]['title']),
                    children: [
                      Html(
                        data: _customer![index]['body'],
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _get();
  }

  _get() async {
    Api api = new Api();
    if (_customer == null) {
      var response = await api.get(Uri.parse('get-shipper-faq'));
      if (response.statusCode == 200) {
        setState(() {
          _customer = jsonDecode(response.body);
        });
      }
    }
  }
}
