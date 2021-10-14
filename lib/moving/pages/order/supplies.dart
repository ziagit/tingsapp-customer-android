import 'dart:convert';

import 'package:customer/moving/pages/order/movers.dart';
import 'package:customer/moving/pages/order/moving_time.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/custom_title.dart';
import 'package:customer/shared/components/error_message.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/components/progress.dart';
import 'package:customer/shared/services/store.dart';

class Supplies extends StatefulWidget {
  @override
  _SuppliesState createState() => _SuppliesState();
}

class _SuppliesState extends State<Supplies> {
  Store store = Store();
  String? _errorMsg;
  bool rememberMe = false;
  List<bool>? _isChecked;
  List? _supplies;
  String? supplyNumber;
  bool _yesTogal = false;
  bool _noTogal = false;

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
              Progress(progress: 100),
              CustomTitle(title: "Do you need moving supplies?"),
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
                  margin: EdgeInsets.only(left: 8, right: 8),
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
                      child: _supplies!.length == 0
                          ? CircularProgressIndicator(color: primary)
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _supplies!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: EdgeInsets.only(
                                      left: 8, right: 8, bottom: 16),
                                  decoration: cardDecoration(context),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 5,
                                        child: Supply(
                                          index: index,
                                          supNumber: _supplies![index]
                                              ['number'],
                                          supName: _supplies![index]['name'],
                                          customFunction: _checkboxTogal,
                                        ),
                                      ),
                                      _isChecked![index]
                                          ? Flexible(
                                              flex: 1,
                                              child: Number(
                                                index: index,
                                                supNumber: _supplies![index]
                                                    ['number'],
                                                supName: _supplies![index]
                                                    ['name'],
                                                customFunction: _inputTogal,
                                              ),
                                            )
                                          : Flexible(child: Container())
                                    ],
                                  ),
                                );
                              },
                            ),
                    )
                  : Container(),
              _yesTogal
                  ? Container()
                  : InkWell(
                      onTap: () {
                        _no(context);
                      },
                      child: Container(
                        height: 70,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(left: 8, top: 16, right: 8),
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
                            child: Text("No thanks",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _noTogal
                                        ? Colors.white
                                        : Colors.black))),
                      ),
                    ),
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
    _init();
  }

  _no(context) {
    setState(() {
      _noTogal = !_noTogal;
    });
    if (_noTogal) {
      for (int i = 0; i < _supplies!.length; i++) {
        _supplies![i]['number'] = 0;
      }
    }
  }

  _init() async {
    var s = await store.read('supplies');
    if (s == null) {
      _getSupplies();
    } else {
      setState(() {
        _supplies = s;
        _isChecked = List<bool>.filled(s.length, false);
      });
      _isItemSelected();
    }
  }

  _isItemSelected() {
    for (int i = 0; i < _supplies!.length; i++) {
      if (int.parse(_supplies![i]['number']) > 0) {
        setState(() {
          _yesTogal = true;
        });
        return;
      }
    }
    setState(() {
      _noTogal = true;
    });
    return;
  }

  _checkboxTogal(index, value) {
    setState(() {
      _isChecked![index] = value;
    });
    if (!value) {
      _supplies![index]['number'] = 0;
    }
  }

  _inputTogal(index, value) {
    setState(() {
      _supplies![index]['number'] = value;
    });
  }

  _back(context) {
    Navigator.pushReplacement(context, SlideLeftRoute(page: MovingTime()));
  }

  _next(context) async {
    if (!_isSelected() && !_noTogal) {
      setState(() {
        _errorMsg = "Please fill out the required fields";
      });
      return;
    }
    await store.save('supplies', _supplies);
    Navigator.pushReplacement(context, SlideRightRoute(page: Movers()));
  }

  bool _isSelected() {
    if (_yesTogal) {
      for (int i = 0; i < _supplies!.length; i++) {
        if (_supplies![i]['number'] is String) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  _getSupplies() async {
    Api api = new Api();
    var response = await api.get('moving-supplies');
    var data = jsonDecode(response.body);
    setState(() {
      _supplies = data;
      _isChecked = List<bool>.filled(data.length, false);
    });
  }
}

class Supply extends StatefulWidget {
  final supNumber;
  final supName;
  final index;
  final customFunction;
  Supply(
      {Key? key, this.index, this.supNumber, this.supName, this.customFunction})
      : super(key: key);

  @override
  _SupplyState createState() => _SupplyState();
}

class _SupplyState extends State<Supply> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      activeColor: primary,
      title: Text("${widget.supName}"),
      controlAffinity: ListTileControlAffinity.leading,
      value: rememberMe,
      onChanged: _onRememberMeChanged,
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    if (widget.supNumber is String) {
      rememberMe = true;
      Future.delayed(Duration.zero, () async {
        widget.customFunction(widget.index, true);
      });
    }
  }

  _onRememberMeChanged(bool? newValue) => setState(
        () {
          rememberMe = newValue!;
          widget.customFunction(widget.index, newValue);
        },
      );
}

class Number extends StatefulWidget {
  final supNumber;
  final supName;
  final index;
  final customFunction;
  Number(
      {Key? key, this.index, this.supNumber, this.supName, this.customFunction})
      : super(key: key);

  @override
  _NumberState createState() => _NumberState();
}

class _NumberState extends State<Number> {
  bool rememberMe = false;

  TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      controller: _numberController,
      keyboardType: TextInputType.number,
      onChanged: _onRememberMeChanged,
      decoration: InputDecoration(
        labelText: 'Qty',
        labelStyle: TextStyle(color: primary),
        border: OutlineInputBorder(),
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primary!,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    if (widget.supNumber is String) {
      rememberMe = true;
    }
    setState(() {
      _numberController.text = widget.supNumber.toString();
    });
  }

  _onRememberMeChanged(String? newValue) => setState(
        () {
          widget.customFunction(widget.index, newValue);
        },
      );
}
