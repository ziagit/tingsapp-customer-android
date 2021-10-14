import 'dart:convert';
import 'package:customer/moving/pages/order/confirm.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/components/slide_top_route.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/components/checkout.dart';
import 'package:customer/shared/services/api.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool _isLoading = true;
  bool _isAdded = false;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
              child: CustomAppbar(),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Payment information",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Visibility(
                        visible: _errorMsg != null,
                        child: Text(
                          "$_errorMsg",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.5,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FutureBuilder(
                      future: _get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Column(
                                children: [
                                  Text("There is no any payment method!"),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 60.0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                primary!),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                        ),
                                      ),
                                      child: Text('Add'),
                                      onPressed: () => _addCard(context, 'new'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              child: Column(
                                children: [
                                  Text(
                                    "A payment method added.",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  TextButton(
                                    child: Text("Add new card"),
                                    onPressed: () {
                                      _addCard(context, 'edit');
                                    },
                                  ),
                                  SizedBox(height: 50),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: ElevatedButton(
                                        child: Text("Continue"),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  primary!),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          _next(context);
                                        }),
                                  )
                                ],
                              ),
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
                      },
                    )
                  ],
                ),
              ),
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
    try {
      var response = await api.get('shipper/card-details');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data.length > 0) {
          return data;
        }
        return null;
      } else {
        setState(() {
          _errorMsg = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  _next(context) {
    Navigator.of(context)
        .pushReplacement(
          SlideRightRoute(
            page: Confirm(),
          ),
        )
        .then((value) => {print("checkout page poped")});
  }

  _addCard(context, status) {
    Navigator.of(context)
        .push(
          SlideTopRoute(
            page: Checkout(status: status),
          ),
        )
        .then((value) => {
              print("----------------------------------------"),
              print(value),
              if (value != null)
                {
                  setState(() {}),
                  //_get()
                }
            });
  }
}
