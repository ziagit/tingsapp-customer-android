import 'dart:convert';

import 'package:customer/moving/pages/order/payment.dart';
import 'package:customer/shared/components/button_style.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/input_decoration2.dart';
import 'package:customer/shared/components/slide_top_route.dart';
import 'package:customer/shared/functions/phone_validator.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/services/store.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Store _store = Store();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  String initialCountry = 'CA';
  PhoneNumber number = PhoneNumber(isoCode: 'CA');
  bool? _isValid;
  bool _isSubmitting = false;
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
              padding: const EdgeInsets.only(top: 30, right: 8, left: 8),
              child: CustomAppbar(),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              margin: EdgeInsets.only(top: 180),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "What is your phone number?",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                      visible: _errorMsg != null,
                      child: Text(
                        "$_errorMsg",
                        style: TextStyle(color: primary),
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: cardDecoration(context),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                          },
                          onInputValidated: (bool value) {
                            _isValid = value;
                          },
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          selectorTextStyle: TextStyle(color: Colors.black),
                          initialValue: number,
                          textFieldController: _phoneController,
                          formatInput: false,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputBorder: OutlineInputBorder(),
                          inputDecoration:
                              inputDecoration2(context, 'Phone number'),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'You’ll receive updates about the status of your order via this phone number.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: fontColor),
                      ),
                      SizedBox(height: 50),
                      _isSubmitting
                          ? CircularProgressIndicator(color: primary)
                          : SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: buttonStyle(context),
                                onPressed: () => {
                                  _continue(context),
                                },
                                child: Text("Continue"),
                              ),
                            ),
                    ],
                  ),
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

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  _continue(context) async {
    Api api = new Api();

    if (!isValidPhone(_phoneController.text)) {
      setState(() {
        _errorMsg = "Please provide a valid phone number";
      });
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    String phone = '+1' + _phoneController.text;
    String token = await _store.read('token');
    await _store.save('phone', phone);
    if (token == null) {
      var response = await api.post(
          jsonEncode(<String, dynamic>{
            'phone': phone,
            'name': "Customer",
            'type': "customer",
          }),
          'auth/verify');
      if (response.statusCode == 200) {
        await _store.save('me', jsonDecode(response.body));
        setState(() {
          _isSubmitting = false;
        });
        Navigator.of(context)
            .push(SlideTopRoute(
              page: Verify(phone: _phoneController.text),
            ))
            .then(
              (value) => {
                if (value != null)
                  {
                    Navigator.pushReplacement(
                        context, SlideTopRoute(page: Payment())),
                  }
              },
            );
      }
    } else {
      Navigator.pushReplacement(context, SlideTopRoute(page: Payment()));
    }
  }
}

//code
class Verify extends StatefulWidget {
  final phone;
  Verify({this.phone});
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  Store _store = Store();
  String? _errorMsg;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _codeController = TextEditingController();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isSubmitting = false;
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black87),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 8, left: 8),
              child: CustomAppbar(),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              margin: EdgeInsets.only(top: 180),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Enter the verification code",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                      visible: _errorMsg != null,
                      child: Text(
                        "$_errorMsg",
                        style: TextStyle(color: primary),
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: cardDecoration(context),
                        child: PinPut(
                          fieldsCount: 4,
                          onSubmit: (String pin) => _continue(pin, context),
                          focusNode: _pinPutFocusNode,
                          controller: _pinPutController,
                          submittedFieldDecoration: _pinPutDecoration.copyWith(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          selectedFieldDecoration: _pinPutDecoration,
                          followingFieldDecoration: _pinPutDecoration.copyWith(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'We texted a code to your phone number.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: fontColor),
                        ),
                      ),
                      SizedBox(height: 50),
                      _isSubmitting
                          ? CircularProgressIndicator(color: primary)
                          : SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: buttonStyle(context),
                                child: Text("Resend"),
                                onPressed: () {
                                  _resend(widget.phone);
                                },
                              ),
                            ),
                    ],
                  ),
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

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  _resend(phone) async {
    Api api = new Api();
    setState(() {
      _isSubmitting = true;
    });
    var response = await api.post(
        jsonEncode(<String, dynamic>{
          'phone': phone,
          'name': "Customer",
          'type': "customer",
        }),
        'auth/verify');
    if (response.statusCode == 200) {
      await _store.save('me', jsonDecode(response.body));
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  _continue(pin, context) async {
    Api api = new Api();
    setState(() {
      _isSubmitting = true;
    });
    try {
      var me = await _store.read('me');
      var response = await api.post(
          jsonEncode(<String, dynamic>{'me': me, 'code': pin}), 'auth/signin');
      if (response.statusCode == 200) {
        await _store.save('token', jsonDecode(response.body));
        await _store.remove('me');
        setState(() {
          _isSubmitting = false;
        });
        Navigator.pop(context, "ok");
      } else {
        setState(() {
          _isSubmitting = false;
          _errorMsg = "Invalid code entered!";
        });
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMsg = "${e.toString()}";
      });
    }
  }
}
