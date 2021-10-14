import 'dart:convert';

import 'package:customer/moving/pages/order/moving_sizes.dart';
import 'package:customer/moving/pages/order/number_of_movers.dart';
import 'package:customer/moving/pages/order/office_sizes.dart';
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

class VehicleSizes extends StatefulWidget {
  @override
  _VehicleSizesState createState() => _VehicleSizesState();
}

class _VehicleSizesState extends State<VehicleSizes> {
  Store _store = Store();
  List? _list = [];
  int? _selectedIndex;
  bool _isLoading = true;
  String? _errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              CustomAppbar(),
              Container(child: Progress(progress: 40)),
              CustomTitle(title: "What size vehicle do you prefer?"),
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
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                flex: 3,
                                child: RadioListTile(
                                  activeColor: primary,
                                  title: Text(_list![index]['name']),
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
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                              )
                            ],
                          ),
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
    var response = await api.get('vehicles');
    if (response.statusCode == 200) {
      _list = jsonDecode(response.body);
      _init();
      return _list;
    } else {
      setState(() {
        _isLoading = false;
      });
      final snackBar = SnackBar(
          content: Text(
        jsonDecode(response.body),
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _init() async {
    var store = await _store.read('vehicle');
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

  _onChanged(vehicle) async {
    await _store.save('vehicle', vehicle);
  }

  void _next(context) async {
    if (_selectedIndex == null) {
      setState(() {
        _errorMsg = "Please fill out the required fields";
      });
    } else {
      Navigator.pushReplacement(
          context, SlideRightRoute(page: NumberOfMovers()));
    }
  }

  void _back(context) async {
    var type = await _store.read('type');
    if (type['code'] == 'apartment') {
      Navigator.pushReplacement(context, SlideLeftRoute(page: MovingSizes()));
    } else if (type['code'] == 'office') {
      Navigator.pushReplacement(context, SlideLeftRoute(page: OfficeSizes()));
    }
  }
}
