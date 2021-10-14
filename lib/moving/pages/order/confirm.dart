import 'package:customer/moving/pages/order/completed.dart';
import 'package:customer/moving/pages/order/floors.dart';
import 'package:customer/moving/pages/order/items.dart';
import 'package:customer/moving/pages/order/moving.dart';
import 'package:customer/moving/pages/order/moving_date.dart';
import 'package:customer/moving/pages/order/moving_sizes.dart';
import 'package:customer/moving/pages/order/moving_types.dart';
import 'package:customer/moving/pages/order/number_of_movers.dart';
import 'package:customer/moving/pages/order/office_sizes.dart';
import 'package:customer/moving/pages/order/supplies.dart';
import 'package:customer/moving/pages/order/vehicle_sizes.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_top_route.dart';
import 'package:customer/shared/functions/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/store.dart';
import 'package:customer/shared/services/colors.dart';
import 'dart:convert';

class Confirm extends StatefulWidget {
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  Store store = Store();
  var _from;
  var _to;
  var _type;
  var _movingSize;
  var _moverNumber;
  var _floors;
  var _contacts;
  var _mover;
  var _movingDate;
  var _vehicle;
  List _supplies = [];
  List _items = [];
  var _distance;
  var _duration;
  var _editable_id;
  var _old_carrier;
  String? _instructions;
  bool _isSubmiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 8, right: 8),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              CustomAppbar(),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: _customStyle(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text("Addresses",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primary)),
                          ),
                          Row(
                            children: [
                              SizedBox(width: 100, child: Text("Pickup: ")),
                              Expanded(
                                  child: Text(
                                      "${_from == null ? '' : _from['formatted_address']}")),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              SizedBox(
                                  width: 100, child: Text("Destination: ")),
                              Expanded(
                                  child: Text(
                                      "${_to == null ? '' : _to['formatted_address'] ?? ''}")),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context, SlideLeftRoute(page: Moving()));
                        },
                        icon: Icon(Icons.edit),
                        iconSize: 18,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Stack(children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Moving type",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: primary)),
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child:
                                Text("${_type == null ? '' : _type['title']}")),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, SlideLeftRoute(page: MovingTypes()));
                      },
                      icon: Icon(Icons.edit),
                      iconSize: 18,
                    ),
                  )
                ]),
              ),
              _movingSize != null
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: _customStyle(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text("Moving size",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primary)),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "${_movingSize == null ? '' : _movingSize['title']}")),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  SlideLeftRoute(
                                      page: _type['code'] == 'office'
                                          ? OfficeSizes()
                                          : MovingSizes()));
                            },
                            icon: Icon(Icons.edit),
                            iconSize: 18,
                          ),
                        )
                      ]),
                    )
                  : Container(),
              _moverNumber != null
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: _customStyle(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text("Movers",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primary)),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "${_moverNumber == null ? '' : _moverNumber['number']}")),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  SlideLeftRoute(page: NumberOfMovers()));
                            },
                            icon: Icon(Icons.edit),
                            iconSize: 18,
                          ),
                        )
                      ]),
                    )
                  : Container(),
              _vehicle != null
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: _customStyle(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text("Vehicle",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primary)),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "${_vehicle == null ? '' : _vehicle['name']}")),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  SlideLeftRoute(page: VehicleSizes()));
                            },
                            icon: Icon(Icons.edit),
                            iconSize: 18,
                          ),
                        )
                      ]),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.all(8),
                child: Stack(children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Pickup date",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: primary)),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Date: ")),
                            Expanded(
                              child: Text(
                                  "${_movingDate == null ? '' : _movingDate['date']}"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("time: ")),
                            Expanded(
                              child: Text(
                                  "${_movingDate == null ? '' : _movingDate['time']}"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, SlideLeftRoute(page: MovingDate()));
                      },
                      icon: Icon(Icons.edit),
                      iconSize: 18,
                    ),
                  )
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Stack(children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Floors",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: primary)),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Pickup: ")),
                            Expanded(
                                child: Text(
                                    "${_floors == null ? '' : _floors['pickup']}")),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 100, child: Text("Destination: ")),
                            Expanded(
                                child: Text(
                                    "${_floors == null ? '' : _floors['destination']}")),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, SlideLeftRoute(page: Floors()));
                      },
                      icon: Icon(Icons.edit),
                      iconSize: 18,
                    ),
                  )
                ]),
              ),
              _supplies != null && _supplies.length > 0
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: _customStyle(context),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Selected supplies",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primary),
                                ),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _supplies.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                            "${_supplies[index]['name']}:"),
                                      ),
                                      Text("${_supplies[index]['number']}")
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context, SlideLeftRoute(page: Supplies()));
                            },
                            icon: Icon(Icons.edit),
                            iconSize: 18,
                          ),
                        )
                      ]),
                    )
                  : Container(),
              _items != null && _items.length > 0
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Stack(children: [
                        Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: _customStyle(context),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Selected items",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primary),
                                ),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child:
                                            Text("${_items[index]['name']}:"),
                                      ),
                                      Text("${_items[index]['number']}")
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context, SlideLeftRoute(page: Items()));
                            },
                            icon: Icon(Icons.edit),
                            iconSize: 18,
                          ),
                        )
                      ]),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: _customStyle(context),
                  child: Center(
                    child: Text(
                      "Price: \$${_mover == null ? '' : _mover['price']}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  child: _isSubmiting
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Submit'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(primary!),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _submit(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Decoration _customStyle(context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        new BoxShadow(
          color: Colors.grey.shade200,
          offset: new Offset(0.0, 10.0),
          blurRadius: 10.0,
          spreadRadius: 1.0,
        )
      ],
    );
  }

  _init() async {
    var from = await store.read('from');
    //reformat lat and long
    from['latlng'] = {};
    from['latlng']['lat'] = from['latitude'];
    from['latlng']['lng'] = from['longitude'];
    var to = await store.read('to');
    to['latlng'] = {};
    to['latlng']['lat'] = to['latitude'];
    to['latlng']['lng'] = to['longitude'];
    var type = await store.read('type');
    var size = await store.read('moving-size');
    var moverNumbers = await store.read('mover-number');
    var vehicle = await store.read('vehicle');
    var xDate = await store.read('moving-date');
    var xTime = await store.read('moving-time');
    var movingDate = {};
    movingDate['date'] = dateFormatter(xDate);
    movingDate['time'] = xTime['from'] + '-' + xTime['to'];

    var floors = await store.read('floors');
    var supplies = await store.read('supplies');
    var items = await store.read('items');
    var mover = await store.read('mover');
    var instructions = await store.read('instructions');
    _contacts = await store.read('contacts');
    _distance = await store.read('distance');
    _duration = await store.read('duration');
    _editable_id = await store.read('editable_id');
    _old_carrier = await store.read('old_carrier');
    setState(
      () {
        _from = from;
        _to = to;
        _type = type;
        _movingSize = size;
        _moverNumber = moverNumbers;
        _vehicle = vehicle;
        _movingDate = movingDate;
        _floors = floors;
        _items = items;
        _mover = mover;
        _instructions = instructions;
        for (int i = 0; i < supplies.length; i++) {
          if (supplies[i]['number'] is String) {
            _supplies.add(supplies[i]);
          }
        }
      },
    );
  }

  void _submit(context) async {
    setState(() {
      _isSubmiting = true;
    });
    var data = jsonEncode(
      <String, Object>{
        "from": _from,
        "to": _to,
        "moving_size": _movingSize,
        "vehicle": _vehicle,
        "number_of_movers": _moverNumber,
        "floors": _floors,
        "moving_date": _movingDate,
        "instructions": _instructions!,
        "contacts": _contacts,
        "items": _items,
        "moving_type": _type,
        "distance": _distance,
        "duration": _duration,
        "supplies": _supplies,
        "carrier": _mover,
        "editable_id": _editable_id,
        "old_carrier": _old_carrier,
      },
    );

    try {
      Api api = new Api();
      var response = await api.post(data, 'confirm');
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        //clean the store
        store.removeAll();
        setState(() {
          _isSubmiting = false;
        });
        Navigator.pushReplacement(
          context,
          SlideTopRoute(
            page: Completed(order: jsonData['uniqid']),
          ),
        );
      } else {
        print(jsonData);
        setState(() {
          _isSubmiting = false;
        });
      }
    } catch (err) {
      setState(() {
        _isSubmiting = false;
      });
      final snackBar = SnackBar(
          content: Text(
        "${err.toString()}",
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return null;
  }
}
