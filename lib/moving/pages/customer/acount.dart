import 'package:customer/shared/services/api.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/services/colors.dart';
import 'dart:convert';
import 'package:customer/shared/services/store.dart';

class Acount extends StatefulWidget {
  @override
  _AcountState createState() => _AcountState();
}

class _AcountState extends State<Acount> {
  String? _name;
  String? _email;
  Store store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.edit,
                color: primary,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: MovingMenu(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
            child: Column(
          children: [
            Text("$_name"),
            Text("$_email"),
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    _getDetails();
    super.initState();
  }

  void _getDetails() async {
    Api api = new Api();
    var response = await api.get('auth/me');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _name = data['name'];
        _email = data['email'];
      });
    } else {
      final snackBar = SnackBar(
          content: Text(
        jsonDecode(response.body),
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
