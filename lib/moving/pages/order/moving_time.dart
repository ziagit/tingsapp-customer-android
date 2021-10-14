import 'dart:convert';

import 'package:customer/moving/pages/order/moving_date.dart';
import 'package:customer/moving/pages/order/supplies.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/custom_title.dart';
import 'package:customer/shared/components/error_message.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/components/progress.dart';
import 'package:customer/shared/services/store.dart';
import 'package:progress_indicators/progress_indicators.dart';

class MovingTime extends StatefulWidget {
  @override
  _MovingTimeState createState() => _MovingTimeState();
}

class _MovingTimeState extends State<MovingTime> {
  Store _store = Store();
  String? _selectedTime;
  List _times = [];
  var _currentDate = new DateTime.now();
  String? _selectedDate;

  String? _errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Container(
        padding: EdgeInsets.only(top: 0, left: 8, right: 8),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            CustomAppbar(),
            Container(child: Progress(progress: 80.0)),
            CustomTitle(title: "What time should your items be picked up?"),
            Visibility(
              visible: _errorMsg != null,
              child: ErrorMessage(msg: "$_errorMsg"),
            ),
            Container(
              child: FutureBuilder(
                future: _get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _times.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.all(18),
                            child: InkWell(
                              onTap: () {
                                _select(_times[index]);
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${_buildTime(_times[index]['from'])}",
                                      style: TextStyle(
                                          fontSize: _times[index]['from'] ==
                                                  _selectedTime
                                              ? 36
                                              : 34,
                                          color: _times[index]['from'] ==
                                                  _selectedTime
                                              ? primary
                                              : fontColor),
                                    ),
                                    Text(
                                      " - ",
                                      style: TextStyle(
                                        fontSize: _times[index]['from'] ==
                                                _selectedTime
                                            ? 28
                                            : 26,
                                        color: _times[index]['from'] ==
                                                _selectedTime
                                            ? primary
                                            : fontColor,
                                      ),
                                    ),
                                    Text(
                                      "${_buildTime(_times[index]['to'])}",
                                      style: TextStyle(
                                        fontSize: _times[index]['from'] ==
                                                _selectedTime
                                            ? 40
                                            : 38,
                                        color: _times[index]['from'] ==
                                                _selectedTime
                                            ? primary
                                            : fontColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(color: primary),
                    );
                  }
                },
              ),
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
              child: Icon(Icons.arrow_back, color: primary),
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
    super.initState();
  }

  Future _get() async {
    Api api = new Api();
    var response = await api.get('times/${_currentDate.day}');
    if (response.statusCode == 200) {
      return _initTime(jsonDecode(response.body));
    }
  }

  _initTime(times) async {
    _selectedDate = await _store.read('moving-date');
    if (_currentDate.isBefore(DateTime.parse(_selectedDate!))) {
      _times = times;
      _init();
      return _times;
    }
    List t = [];
    for (int i = 0; i < times.length; i++) {
      if (int.parse(times[i]['from']) > _currentDate.hour) {
        t.add(times[i]);
      }
    }
    _times = t;
    _init();
    return _times;
  }

  _back(context) {
    Navigator.pushReplacement(context, SlideLeftRoute(page: MovingDate()));
  }

  _select(time) async {
    setState(() {
      _selectedTime = time['from'];
    });
    await _store.save('moving-time', time);
  }

  _next(context) async {
    if (_selectedTime == null) {
      setState(() {
        _errorMsg = "Please select your prefered time";
      });
    } else {
      Navigator.pushReplacement(context, SlideRightRoute(page: Supplies()));
    }
  }

  _init() async {
    var data = await _store.read('moving-time');
    if (data != null) {
      setState(() {
        _selectedTime = data['from'];
      });
    }
  }

  String _buildTime(time) {
    return int.parse(time) < 10 ? '0' + time + ':00' : time + ':00';
  }
}
