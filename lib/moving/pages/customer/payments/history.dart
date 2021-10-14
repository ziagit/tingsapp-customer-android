import 'dart:convert';

import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List? _histories = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: _get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Container(child: Text("No payment history"));
                } else {
                  return DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text("Order"),
                        numeric: false,
                        onSort: (i, b) {},
                      ),
                      DataColumn(
                        label: Text("Date"),
                        numeric: false,
                        onSort: (i, b) {},
                      ),
                      DataColumn(
                        label: Text("Cost"),
                        numeric: false,
                        onSort: (i, b) {},
                      ),
                      DataColumn(
                        label: Text("Given tips"),
                        numeric: false,
                        onSort: (i, b) {},
                      ),
                      DataColumn(
                        label: Text("Total"),
                        numeric: false,
                        onSort: (i, b) {},
                      ),
                    ],
                    rows: _histories!
                        .map(
                          (history) => DataRow(
                            cells: [
                              DataCell(Text("\$${history['uniqid']}"),
                                  showEditIcon: false, placeholder: false),
                              DataCell(Text("\$${history['pickup_date']}"),
                                  showEditIcon: false, placeholder: false),
                              DataCell(Text("\$${history['cost']}"),
                                  showEditIcon: false, placeholder: false),
                              DataCell(Text("${history['tips'] ?? 'None'}"),
                                  showEditIcon: false, placeholder: false),
                              DataCell(
                                  Text(
                                      "\$${_subtotal(history['cost'], history['tips'] == null ? 0 : history['tips'])}"),
                                  showEditIcon: false,
                                  placeholder: false),
                            ],
                          ),
                        )
                        .toList(),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(child: CircularProgressIndicator(color: primary));
              } else {
                return Center(
                  child: CircularProgressIndicator(color: primary),
                );
              }
            },
          )),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _subtotal(cost, tips) {
    if (tips == null) {
      return cost;
    }
    return cost + tips;
  }

  _get() async {
    Api api = new Api();
    var response = await api.get('shipper/charge-details');
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      _histories = jsonData;
      return _histories;
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
