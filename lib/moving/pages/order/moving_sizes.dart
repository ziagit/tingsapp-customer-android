import 'dart:convert';

import 'package:customer/moving/pages/order/moving_types.dart';
import 'package:customer/moving/pages/order/vehicle_sizes.dart';
import 'package:customer/shared/components/card_decoration.dart';
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

class MovingSizes extends StatefulWidget {
  @override
  _MovingSizesState createState() => _MovingSizesState();
}

class _MovingSizesState extends State<MovingSizes> {
  Store _store = Store();
  List? _list = [];
  int? _selectedIndex;
  String? _errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Padding(
        padding: EdgeInsets.only(top: 0, left: 8, right: 8),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              CustomAppbar(),
              Container(child: Progress(progress: 30)),
              CustomTitle(title: "What is your moving size?"),
              Visibility(
                  visible: _errorMsg != null,
                  child: ErrorMessage(msg: "$_errorMsg")),
              Form(
                  child: FutureBuilder(
                future: _get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: _list!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          decoration: cardDecoration(context),
                          child: Flex(direction: Axis.horizontal, children: [
                            Flexible(
                              flex: 3,
                              child: RadioListTile(
                                activeColor: primary,
                                title: Text(_list![index]['title']),
                                value: index,
                                groupValue: _selectedIndex,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedIndex =
                                        int.parse(value.toString());
                                  });
                                  _onChanged(_list![index]);
                                },
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                "${_list![index]['recommended']}",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ),
                          ]),
                        );
                      },
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
              )),
            ],
          ),
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
    var response = await api.get('moving-sizes');
    if (response.statusCode == 200) {
      _list = jsonDecode(response.body);
      _init();
      return _list;
    } else {
      final snackBar = SnackBar(
          content: Text(
        jsonDecode(response.body),
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _init() async {
    var store = await _store.read('moving-size');
    if (store != null) {
      for (int i = 0; i < _list!.length; i++) {
        if (_list![i]['code'] == store['code']) {
          setState(() {
            _selectedIndex = i;
          });
        }
      }
    }
  }

  _onChanged(size) async {
    await _store.save('moving-size', size);
  }

  void _next(context) async {
    if (_selectedIndex != null) {
      Navigator.pushReplacement(context, SlideRightRoute(page: VehicleSizes()));
    } else {
      setState(() {
        _errorMsg = "Please fill out the required fields";
      });
    }
  }

  void _back(context) async {
    Navigator.pushReplacement(context, SlideLeftRoute(page: MovingTypes()));
  }
}
