import 'dart:convert';

import 'package:customer/moving/pages/order/from.dart';
import 'package:customer/moving/pages/order/moving_types.dart';
import 'package:customer/moving/pages/order/to.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/public/home.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/moving/moving_appbar.dart';
import 'package:customer/shared/components/progress.dart';

class Moving extends StatefulWidget {
  @override
  _MovingState createState() => _MovingState();
}

class _MovingState extends State<Moving> {
  var _supportedArea = [];
  Store _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MovingAppBar(),
      drawer: MovingMenu(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 20.0),
            Container(child: Progress(progress: 0)),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.fromLTRB(8, 18, 8, 0),
              child: From(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 18, 8, 0),
              child: To(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: 1,
              onPressed: () => _back(context),
              child: Icon(
                Icons.arrow_back,
                color: primary,
              ),
            ),
            FloatingActionButton(
              backgroundColor: primary,
              heroTag: 2,
              onPressed: () => _next(context),
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _getSupportedAreas();
    super.initState();
  }

  _getSupportedAreas() async {
    Api api = new Api();
    var response = await api.get('state-cities');
    if (response.statusCode == 200) {
      _supportedArea = jsonDecode(response.body);
    } else {
      final snackBar = SnackBar(
          content: Text(
        "${response.body}",
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _next(context) async {
    var from = await _store.read('from');
    var to = await _store.read('to');
    if (from == null || to == null) {
      _invalidDialog(context, 'Please provide a valid address!');
    } else {
      if (await _checkState(from) && await _checkCity(from)) {
        if (await _checkState(to) && await _checkCity(to)) {
          Navigator.pushReplacement(
              context,
              SlideRightRoute(
                page: MovingTypes(),
              ));
        } else {
          _invalidDialog(context,
              'The destination location is out of our current service area. We are working on expanding our coverage.');
        }
      } else {
        _invalidDialog(context,
            'The pickup location is out of our current service area. We are working on expanding our coverage.');
      }
    }
  }

  void _back(context) async {
    Navigator.pushReplacement(context, SlideLeftRoute(page: Home()));
  }

  //check state
  _checkState(selected) async {
    for (int i = 0; i < _supportedArea.length; i++) {
      if (this._supportedArea[i]['name'] == selected['state']) {
        return true;
      }
    }
    return false;
  }

  //check city
  _checkCity(selected) async {
    for (int i = 0; i < _supportedArea.length; i++) {
      for (int j = i; j < _supportedArea[i]['cities'].length; j++) {
        if (_supportedArea[i]['cities'][j]['name'] == selected['city']) {
          return true;
        }
      }
    }
    return false;
  }

  _invalidDialog(context, message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Invalid address!'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Stack(
          children: [
            Builder(
              builder: (context) {
                var width = MediaQuery.of(context).size.width;
                return Container(
                  width: width,
                  child: Text(message),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Ok',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    ).then((value) {
      //
    });
  }
}
