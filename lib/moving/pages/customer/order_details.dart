import 'dart:convert';

import 'package:customer/moving/pages/order/map.dart';
import 'package:customer/moving/pages/order/moving.dart';
import 'package:customer/moving/pages/tracking/tracking.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/functions/edit_order.dart';
import 'package:flutter/material.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:customer/shared/functions/date_formatter.dart';

class OrderDetails extends StatefulWidget {
  final id;
  OrderDetails({Key? key, this.id});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool _isLoading = true;
  var _order;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Status: ${_isLoading ? '' : _order['status']}",
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.track_changes,
                color: Colors.black87,
              ),
              onPressed: () {
                _track(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      body: Container(
          child: FutureBuilder(
        future: _get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16, 20, 16, 10),
                  padding: EdgeInsets.all(20.0),
                  decoration: cardDecoration(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Order Details",
                            style: TextStyle(color: primary, fontSize: 18.0)),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Order:")),
                          Text("${_order['uniqid']}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Placed on:")),
                          Text("${dateFormatter(_order['created_at'])}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Pickup:")),
                          Flexible(
                            child: Text(
                                "${_order['addresses'][0]['formatted_address']}"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Floor:")),
                          Text("${_order['floor_from']}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Destination:")),
                          Flexible(
                            child: Text(
                                "${_order['addresses'][1]['formatted_address']}"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Floor:")),
                          Text("${_order['floor_to']}")
                        ],
                      ),
                      _order['movingtype']['code'] == 'apartment'
                          ? Row(
                              children: [
                                SizedBox(
                                    width: 100, child: Text("Moving size:")),
                                Text("${_order['movingsize']['title']}")
                              ],
                            )
                          : Container(),
                      _order['movingtype']['code'] == 'office'
                          ? Row(
                              children: [
                                SizedBox(
                                    width: 100, child: Text("Office size:")),
                                Text("${_order['officesize']['title']}")
                              ],
                            )
                          : Container(),
                      _order['movernumber'] != null
                          ? Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text("Number of movers:")),
                                Text("${_order['movernumber']['number']}")
                              ],
                            )
                          : Container(),
                      _order['vehicle'] != null
                          ? Row(
                              children: [
                                SizedBox(width: 100, child: Text("Vehicle:")),
                                Text("${_order['vehicle']['name']}")
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Schedual date:")),
                          Text("${_order['pickup_date']}")
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Time window:")),
                          Text("${_order['appointment_time']}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Instructions:")),
                          Flexible(
                            child: Text(
                                "${_order['instructions'] != null ? _order['instructions'] : ''}"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                _order['supplies'].length > 0
                    ? Container(
                        margin: EdgeInsets.fromLTRB(16, 10.0, 16, 10),
                        padding: EdgeInsets.all(20.0),
                        decoration: cardDecoration(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Supplies",
                                style:
                                    TextStyle(color: primary, fontSize: 18.0),
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _order['supplies'].length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                    "${_order['supplies'][index]['name']}:"),
                                              ),
                                              Text(
                                                  "${_order['supplies'][index]['pivot']['number']}")
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                _order['items'].length > 0
                    ? Container(
                        margin: EdgeInsets.fromLTRB(16, 10.0, 16, 10),
                        padding: EdgeInsets.all(20.0),
                        decoration: cardDecoration(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Items",
                                style:
                                    TextStyle(color: primary, fontSize: 18.0),
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _order['items'].length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.all(0.0),
                                      title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                    "${_order['items'][index]['name']}:"),
                                              ),
                                              Text(
                                                  "${_order['items'][index]['pivot']['number']}")
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                  padding: EdgeInsets.all(20.0),
                  decoration: cardDecoration(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Price",
                          style: TextStyle(color: primary, fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Total:")),
                          Text("\$${_order['cost']}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Moving cost:")),
                          Text("\$${_order['moving_cost']}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Travel cost:")),
                          Text("\$${_order['travel_cost']}")
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Service fee:")),
                          Text("\$${_order['service_fee']}")
                        ],
                      ),
                      _order['disposal_fee'] != null
                          ? Row(
                              children: [
                                SizedBox(
                                    width: 100, child: Text("Disposal fee:")),
                                Text("\$${_order['disposal_fee']}")
                              ],
                            )
                          : Container(),
                      _order['tips'] != null
                          ? Row(
                              children: [
                                SizedBox(width: 100, child: Text("Tips:")),
                                Text("\$${_order['tips']}")
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                  padding: EdgeInsets.all(20.0),
                  decoration: cardDecoration(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mover Contacts",
                          style: TextStyle(color: primary, fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Name:")),
                          Flexible(
                            child: Text(
                                "${_order['job_with_carrier']['carrier_detail']['user']['name']}"),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Email:")),
                          Flexible(
                            child: Text(
                                "${_order['job_with_carrier']['carrier_detail']['user']['email']}"),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text("Phone:")),
                          Text(
                              "${_order['job_with_carrier']['carrier_detail']['user']['phone']}")
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
      floatingActionButton: buildSpeedDial(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future _get() async {
    Api api = new Api();
    var response = await api.get('shipper/orders/${widget.id}');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _order = data;
      setState(() {
        _isLoading = false;
      });
      return _order;
    } else {
      final snackBar = SnackBar(
          content: Text(
        jsonDecode(response.body),
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _update(status) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    if (status == 'Canceled') {
      var data = jsonEncode(<String, Object>{
        'status': status,
        'phone': _order['job_with_carrier']['carrier_detail']['user']['phone'],
        'email': _order['job_with_carrier']['carrier_detail']['user']['email'],
        'jobId': _order['job_with_carrier']['id'],
      });
      var res = await api.update(data, "shipper/orders/${widget.id}");
      if (res.statusCode == 200) {
        _get();
        setState(() {
          _isLoading = false;
        });
        final snackBar = SnackBar(content: Text("Job updated!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print("......................");
        print("something is wronge");
      }
    } else {
      editOrder(_order).then((value) => {}).whenComplete(
            () => {
              print("completed................."),
              Navigator.pushReplacement(context, SlideLeftRoute(page: GMap())),
            },
          );
    }
  }

  _track(context) {
    Navigator.pushReplacement(context,
        SlideRightRoute(page: Tracking(trackingNumber: _order['uniqid'])));
  }

  //speed dial

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.menu,
      activeIcon: Icons.close,
      buttonSize: 56.0,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.cancel),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          label: 'Cancel',
          labelStyle: TextStyle(fontSize: 16.0),
          onTap: () => _update('Canceled'),
        ),
        SpeedDialChild(
          child: Icon(Icons.check_rounded),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          label: 'Edit',
          labelStyle: TextStyle(fontSize: 16.0),
          onTap: () => _update('Edited'),
        ),
      ],
    );
  }
}
