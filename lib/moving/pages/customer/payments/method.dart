import 'dart:convert';

import 'package:customer/shared/components/checkout.dart';
import 'package:customer/shared/components/slide_top_route.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';

class Methods extends StatefulWidget {
  const Methods({Key? key}) : super(key: key);

  @override
  _MethodsState createState() => _MethodsState();
}

class _MethodsState extends State<Methods> {
  List? _methods = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
              future: _get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return Container(child: Text("No payment method added"));
                  } else {
                    return DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text("Type"),
                          numeric: false,
                          onSort: (i, b) {},
                        ),
                        DataColumn(
                          label: Text("Details"),
                          numeric: false,
                          onSort: (i, b) {},
                        ),
                        DataColumn(
                          label: Text("Exp date"),
                          numeric: false,
                          onSort: (i, b) {},
                        ),
                        DataColumn(
                          label: Text("Edit"),
                          numeric: false,
                          onSort: (i, b) {},
                        ),
                      ],
                      rows: _methods!
                          .map(
                            (method) => DataRow(
                              cells: [
                                DataCell(Text(method['brand']),
                                    showEditIcon: false, placeholder: false),
                                DataCell(Text(method['last4']),
                                    showEditIcon: false, placeholder: false),
                                DataCell(
                                    Text("${method['exp_month']}" +
                                        "/" +
                                        "${method['exp_year']}"),
                                    showEditIcon: false,
                                    placeholder: false),
                                DataCell(
                                    IconButton(
                                      icon: Icon(Icons.edit, color: primary),
                                      onPressed: () {
                                        _editMethod(context);
                                      },
                                    ),
                                    showEditIcon: false,
                                    placeholder: false),
                              ],
                            ),
                          )
                          .toList(),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(color: primary));
                }
              },
            )),
      ),
      floatingActionButton: _methods!.length > 0
          ? Container()
          : FloatingActionButton(
              backgroundColor: primary,
              onPressed: () {
                _editMethod(context);
              },
              child: Icon(Icons.add),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future _get() async {
    Api api = new Api();
    var response = await api.get('shipper/card-details');
    if (response.statusCode == 200) {
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      var jsonData = jsonDecode(response.body);
      _methods = jsonData.length > 0 ? jsonData['data'] : [];
      return _methods;
    } else {
      final snackBar = SnackBar(
          content: Text(
        jsonDecode(response.body),
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _editMethod(context) {
    Navigator.of(context)
        .push(
          SlideTopRoute(
            page: Checkout(),
          ),
        )
        .then(
          (value) => {
            if (value != null)
              {
                _get(),
              }
          },
        );
  }
}
