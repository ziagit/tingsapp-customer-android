import 'dart:convert';

import 'package:customer/moving/pages/customer/order_details.dart';
import 'package:customer/moving/pages/order/map.dart';
import 'package:customer/moving/pages/order/moving.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/components/slide_scale_route.dart';
import 'package:customer/shared/functions/date_formatter.dart';
import 'package:customer/shared/services/api.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Store store = Store();
  List _orders = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
        child: Column(
          children: [
            CustomAppbar(),
            FutureBuilder(
                future: _get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("you have not moved yet"),
                            SizedBox(height: 20.0),
                            TextButton(
                              child: Text(
                                "Start new move",
                                style: TextStyle(fontSize: 12.0),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context, SlideScaleRoute(page: GMap()));
                              },
                            )
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.fromLTRB(8, 24, 8, 16),
                        decoration: cardDecoration(context),
                        child: bodyData(),
                      );
                    }
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
                })
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget bodyData() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: Text("Pickup"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("Destination"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("Date"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("Status"),
                numeric: false,
                onSort: (i, b) {},
              ),
              DataColumn(
                label: Text("Details"),
                numeric: false,
                onSort: (i, b) {},
              ),
            ],
            rows: _orders
                .map(
                  (order) => DataRow(
                    cells: [
                      DataCell(
                          Text(
                            order['addresses'][1]['city'],
                          ),
                          showEditIcon: false,
                          placeholder: false),
                      DataCell(Text(order['addresses'][1]['city']),
                          showEditIcon: false, placeholder: false),
                      DataCell(Text(dateFormatter(order['created_at'])),
                          showEditIcon: false, placeholder: false),
                      DataCell(Text(order['status']),
                          showEditIcon: false, placeholder: false),
                      DataCell(
                          IconButton(
                            icon: Icon(Icons.more_horiz, color: primary),
                            onPressed: () {
                              _edit(order['id']);
                            },
                          ),
                          showEditIcon: false,
                          placeholder: false),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      );

  Future _get() async {
    Api api = new Api();
    var response = await api.get('shipper/orders');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _orders = data;
      return _orders;
    } else {
      final snackBar = SnackBar(
          content: Text(
        jsonDecode(response.body),
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _edit(id) {
    Navigator.push(context, SlideRightRoute(page: OrderDetails(id: id)));
  }
}
