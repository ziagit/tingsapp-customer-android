import 'dart:convert';

import 'package:customer/moving/models/user.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Verify extends StatefulWidget {
  final phone;
  const Verify({Key? key, this.phone}) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isLoading = false;
  Store _store = Store();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primary,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signin');
          },
        ),
        iconTheme: IconThemeData(color: primary),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: Image(image: AssetImage("assets/images/logo.png")),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Verify",
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(height: 26.0),
                Container(
                  child: PinPut(
                    fieldsCount: 4,
                    onSubmit: (String pin) => _navigate(pin, context),
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "We texted a code to your email/phone",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: _isLoading
                      ? CircularProgressIndicator(color: primary)
                      : TextButton(
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
    );
  }

  _resend(phone) async {
    print(phone);
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{'email': phone},
        ),
        'auth/check-email');
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      await _store.save('me', jsonData['id']);
      setState(() {
        _isLoading = false;
      });
    } else {
      _errorSnackbar(jsonDecode(response.body));
    }
  }

  void _navigate(String pin, BuildContext context) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    int me = await _store.read('me');
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{"code": pin, "me": me},
        ),
        'auth/signin');
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      _store.save('token', jsonData);
      var me = await api.get('auth/me');
      if (me.statusCode == 200) {
        var jsonUser = jsonDecode(me.body);
        User u = User(jsonUser['id'], jsonUser['avatar'], jsonUser['name'],
            jsonUser['email'], jsonUser['phone'], '', '');
        await _store.save('user', u);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, 'ok');
    } else {
      _errorSnackbar(jsonDecode(response.body));
    }
  }

  _errorSnackbar(error) {
    final snackBar = SnackBar(
      content: Text("$error"),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
