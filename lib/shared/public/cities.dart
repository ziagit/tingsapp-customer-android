import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';

class Cities extends StatefulWidget {
  @override
  _CitiesState createState() => _CitiesState();
}

class _CitiesState extends State<Cities> {
  List _countries = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Covered Cities",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: _countries.length == 0
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Loading"),
                    JumpingDotsProgressIndicator(
                      fontSize: 20.0,
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _countries.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${_countries[index]['name']}"),
                            Divider(),
                            Container(
                              margin: EdgeInsets.fromLTRB(30, 10, 10, 10),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _countries[index]
                                        ['states_and_cities']
                                    .length,
                                itemBuilder: (context, ind) {
                                  return Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_countries[index]['states_and_cities'][ind]['name']}",
                                        ),
                                        Divider(),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              30, 10, 10, 10),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _countries[index]
                                                        ['states_and_cities']
                                                    [ind]['cities']
                                                .length,
                                            itemBuilder: (context, ix) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${_countries[index]['states_and_cities'][ind]['cities'][ix]['name']}"),
                                                  Divider(),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
      ),
    );
  }

  @override
  void initState() {
    _get();
    super.initState();
  }

  _get() async {
    Api api = new Api();
    var response = await api.get('countries-full');
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        _countries = jsonData;
      });
    } else {
      print("error");
    }
  }
}
