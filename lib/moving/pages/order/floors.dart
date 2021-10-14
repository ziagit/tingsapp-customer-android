import 'package:customer/moving/pages/order/items.dart';
import 'package:customer/moving/pages/order/moving_date.dart';
import 'package:customer/moving/pages/order/number_of_movers.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/custom_title.dart';
import 'package:customer/shared/components/error_message.dart';
import 'package:customer/shared/components/input_decoration.dart';
import 'package:customer/shared/components/progress.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/services/store.dart';

class Floors extends StatefulWidget {
  @override
  _FloorsState createState() => _FloorsState();
}

class _FloorsState extends State<Floors> {
  TextEditingController _pickupController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  Store _store = Store();
  bool _yesTogal = false;
  bool _noTogal = false;
  bool _atPickup = false;
  bool _atDestination = false;
  bool _isJanckRemoval = false;
  String? _errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Padding(
        padding: EdgeInsets.only(top: 0, left: 8, right: 8),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            CustomAppbar(),
            Container(child: Progress(progress: 60)),
            CustomTitle(title: "Do movers need to use stairs?"),
            Visibility(
                visible: _errorMsg != null,
                child: ErrorMessage(msg: "$_errorMsg")),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  _yesTogal = !_yesTogal;
                });
                if (_yesTogal) {
                  _noTogal = false;
                }
              },
              child: Container(
                height: 70,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _yesTogal ? primary : Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey.shade200,
                      offset: new Offset(0.0, 10.0),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                    )
                  ],
                ),
                child: Center(
                    child: Text(
                  "Yes",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _yesTogal ? Colors.white : Colors.black),
                )),
              ),
            ),
            _yesTogal
                ? Container(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          decoration: cardDecoration(context),
                          child: CheckboxListTile(
                            activeColor: primary,
                            contentPadding: EdgeInsets.all(0),
                            title: Text("At pickup site"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _atPickup,
                            onChanged: (value) => {
                              setState(
                                () {
                                  _atPickup = value!;
                                },
                              )
                            },
                          ),
                        ),
                        _atPickup
                            ? Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Icon(Icons.subdirectory_arrow_right),
                                    SizedBox(width: 30),
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: cardDecoration(context),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _pickupController,
                                          decoration: inputDecoration(
                                              context, 'Number of floors'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        _isJanckRemoval
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.all(8),
                                decoration: cardDecoration(context),
                                child: CheckboxListTile(
                                  activeColor: primary,
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text("At destination"),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: _atDestination,
                                  onChanged: (value) => {
                                    setState(
                                      () {
                                        _atDestination = value!;
                                      },
                                    )
                                  },
                                ),
                              ),
                        _isJanckRemoval
                            ? Container()
                            : _atDestination
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 20),
                                        Icon(Icons.subdirectory_arrow_right),
                                        SizedBox(width: 30),
                                        Flexible(
                                          child: Container(
                                            decoration: cardDecoration(context),
                                            padding: const EdgeInsets.all(8),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  _destinationController,
                                              decoration: inputDecoration(
                                                  context, 'Number of floors'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                      ],
                    ),
                  )
                : Container(),
            _yesTogal
                ? Container()
                : InkWell(
                    onTap: () {
                      setState(() {
                        _noTogal = !_noTogal;
                      });
                    },
                    child: Container(
                      height: 70,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _noTogal ? primary : Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.grey.shade200,
                            offset: new Offset(0.0, 10.0),
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                          )
                        ],
                      ),
                      child: Center(
                          child: Text("No",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _noTogal ? Colors.white : Colors.black))),
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
    _init();
  }

  _next(context) async {
    if (!_yesTogal && !_noTogal) {
      setState(() {
        _errorMsg = "Please fill the required fields";
      });
      return;
    }
    if (_noTogal) {
      _atPickup = false;
      _atDestination = false;
      await _store.remove('floors');
    }

    if (_yesTogal) {
      if (!_atPickup && !_atDestination) {
        setState(() {
          _errorMsg = "Please fill the required fields";
        });
        return;
      }
    }
    if (!_atPickup) {
      _pickupController.text = "";
    }
    if (!_atDestination) {
      _destinationController.text = "";
    }
    if (!_atPickup && !_atDestination) {
      await _store.remove('floors');
    } else {
      await _store.save('floors', {
        'pickup': _pickupController.text,
        'destination': _destinationController.text,
      });
    }
    if ((_atPickup && _pickupController.text.length == 0) ||
        (_atDestination && _destinationController.text.length == 0)) {
      setState(() {
        _errorMsg = "The selected checkbox is required";
      });
    } else if ((_atPickup && int.parse(_pickupController.text) < 2) ||
        (_atDestination && int.parse(_destinationController.text) < 2)) {
      setState(() {
        _errorMsg = "The value must be greater than 2";
      });
    } else {
      Navigator.pushReplacement(context, SlideRightRoute(page: MovingDate()));
    }
  }

  _back(context) async {
    var store = await _store.read('type');
    if (store['code'] == 'apartment' || store['code'] == 'office') {
      Navigator.pushReplacement(
          context, SlideLeftRoute(page: NumberOfMovers()));
    } else {
      Navigator.pushReplacement(context, SlideLeftRoute(page: Items()));
    }
  }

  _init() async {
    var movigType = await _store.read('type');
    var floors = await _store.read('floors');
    if (movigType['code'] == 'junk_removal') {
      setState(() {
        _isJanckRemoval = true;
      });
    }
    if (floors != null) {
      if (floors['pickup'] != "" && floors['pickup'] != null) {
        setState(() {
          _yesTogal = true;
          _atPickup = true;
          _pickupController.text = floors['pickup'].toString();
        });
      }
      if (floors['destination'] != "" && floors['destination'] != null) {
        setState(() {
          _yesTogal = true;
          _atDestination = true;
          _destinationController.text = floors['destination'].toString();
        });
      }
    }
  }
}
