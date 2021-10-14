import 'dart:convert';

import 'package:customer/moving/models/mover_model.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/moving/pages/order/contacts.dart';
import 'package:customer/moving/pages/order/map.dart';
import 'package:customer/moving/pages/order/payment.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/functions/build_order.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/store.dart';

class Movers extends StatefulWidget {
  @override
  _MoversState createState() => _MoversState();
}

class _MoversState extends State<Movers> {
  Store _store = Store();
  bool _isLoading = true;
  Mover? _mover;
  String? _notFoundMessage;
  TextEditingController _instructionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
              child: CustomAppbar(),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              height: MediaQuery.of(context).size.height * 0.5,
              child: _isLoading
                  ? Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(color: primary),
                    )
                  : _mover == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text(_notFoundMessage!)])
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Your price:",
                                  style: TextStyle(
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.info, color: primary),
                                  onPressed: () => {_priceBreakdown(context)},
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "\$${_mover!.price}",
                                  style: TextStyle(
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Damage protection included.",
                              style: TextStyle(color: primary, fontSize: 18),
                            )
                          ],
                        ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: _customStyle(context),
                padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: cardDecoration(context),
                        child: TextFormField(
                          controller: _instructionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Add a note (optional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.text_snippet),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      _mover == null
                          ? Container()
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
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
                                child: Text(
                                  "Place order",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18),
                                ),
                                onPressed: () {
                                  _next(context);
                                },
                              ),
                            ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              SlideRightRoute(page: GMap()),
                            );
                          },
                          child: Text("Do you want to edit?",
                              style: TextStyle(color: primary)),
                        ),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  Decoration _customStyle(context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
    );
  }

  _init() async {
    Api api = new Api();
    var from = await _store.read('from');
    var to = await _store.read('to');
    var response = await api.getGoogleMapDestance(from, to);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['rows'][0]['elements'][0]['status'] == 'OK') {
        await _store.save('distance',
            (data['rows'][0]['elements'][0]['distance']['value'] / 1000));
        await _store.save(
          'duration',
          (data['rows'][0]['elements'][0]['duration']['value'] / 60)
              .toStringAsFixed(0),
        );
      }
    } else {
      final snackBar = SnackBar(
          content: Text(
        jsonDecode(response.body),
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    await buildOrder().then(
      (value) => {
        _get(value),
      },
    );
  }

  _get(order) async {
    Api api = new Api();
    var response = await api.post(
        jsonEncode(<String, dynamic>{
          "moving_type": order['moving_type'],
          "from": order['from'],
          "to": order['to'],
          "contacts": order['contacts'],
          "moving_date": order['moving_date'],
          "moving_size": order['moving_size'],
          "number_of_movers": order['number_of_movers'],
          "supplies": order['supplies'],
          "vehicle": order['vehicle'],
          "items": order['items'],
          "distance": order['distance'],
          "duration": order['duration'],
        }),
        'carriers-rate');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200 && jsonData.length > 0) {
      _mover = Mover(
        jsonData['id'],
        jsonData['first_name'],
        jsonData['last_name'],
        jsonData['year_established'],
        jsonData['employees'],
        jsonData['vehicles'],
        jsonData['hourly_rate'],
        jsonData['phone'],
        jsonData['price'].toDouble(),
        jsonData['company'],
        jsonData['detail'],
        jsonData['votes'].toDouble(),
        jsonData['website'],
        jsonData['logo'],
        jsonData['travel']!.toDouble(),
        jsonData['moving']!.toDouble(),
        jsonData['supplies_cost']!.toDouble(),
        jsonData['service_fee']!.toDouble(),
        jsonData['disposal_fee']!.toDouble(),
        jsonData['tax']!.toDouble(),
      );

      await _store.save('mover', _mover);
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _notFoundMessage =
            'Something is wrong, please check the Source or Destination!';
      });
      final snackBar = SnackBar(
        content:
            Text('Something is wrong, please check the Source or Destination!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _next(context) async {
    await _store.save('instructions', _instructionController.text);
    String token = await _store.read('token');
    if (token == null) {
      Navigator.pushReplacement(context, SlideRightRoute(page: Contacts()));
    } else {
      Navigator.pushReplacement(context, SlideRightRoute(page: Payment()));
    }
  }

  _priceBreakdown(context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Moving:",
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
              Text("\$${_mover!.moving}",
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Travel:",
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
              Text("\$${_mover!.travel}",
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5))
            ]),
            Visibility(
              visible: _mover!.supplies_cost != 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Supplies:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, height: 1.5)),
                    Text("\$${_mover!.supplies_cost}",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, height: 1.5))
                  ]),
            ),
            Visibility(
              visible: _mover!.disposal_fee != 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Disposal fee:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, height: 1.5)),
                    Text("\$${_mover!.disposal_fee}",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, height: 1.5))
                  ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Tax:",
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
              Text("\$${_mover!.tax}",
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
            ]),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Total:",
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
              Text("\$${_calculateTotal()}",
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1.5)),
            ]),
            SizedBox(height: 10),
            Text(
                " The price includes basic damage protection. Your items are covered up to 60 cents per pound per item. This is the minimum coverage required by law. If you would like additional coverage, please contact your home/tenant insurance provider.")
          ]),
        );
      },
    );
  }

  _calculateTotal() {
    return (_mover!.travel! +
            _mover!.moving! +
            _mover!.supplies_cost! +
            _mover!.tax!)
        .toStringAsFixed(2);
  }
}
