import 'dart:convert';

import 'package:customer/moving/pages/order/map.dart';
import 'package:customer/shared/auth/password.dart';
import 'package:customer/shared/auth/verify.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/input_decoration2.dart';
import 'package:customer/shared/components/slide_left_route.dart';
//import 'package:customer/shared/auth/social_login.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/functions/email_validator.dart';
import 'package:customer/shared/functions/phone_validator.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  Store _store = Store();
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
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
            Navigator.pushReplacement(context, SlideLeftRoute(page: GMap()));
          },
        ),
        iconTheme: IconThemeData(color: primary),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: Image(image: AssetImage("assets/images/logo.png")),
                ),
                SizedBox(height: 20.0),
                Text(
                  "SignIn",
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(height: 26.0),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: cardDecoration(context),
                          child: TextFormField(
                            controller: _emailController,
                            decoration:
                                inputDecoration2(context, 'Email/phone'),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter a valid email/phone';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 26.0),
                        _isLoading
                            ? CircularProgressIndicator(
                                color: primary,
                              )
                            : SizedBox(
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
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    _login(context);
                                  },
                                ),
                              ),
                        SizedBox(height: 20),
                        /* Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text(
                                  "Sign up for a new account",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/signup');
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.mail, color: Colors.red),
                                    onPressed: () => _socialLogin('google')),
                                IconButton(
                                    icon: Icon(Icons.facebook,
                                        color: Colors.lightBlue),
                                    onPressed: () => _socialLogin('facebook')),
                                IconButton(
                                    icon: Icon(Icons.title,
                                        color: Colors.lightBlueAccent),
                                    onPressed: () => _socialLogin('twitter')),
                              ],
                            ) */
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),

      // child: Text("This is where your content goes")
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _login(context) async {
    if (isValidPhone(_emailController.text)) {
      String phone = '+1' + _emailController.text;
      _continue(phone);
    } else if (isValidEmail(_emailController.text)) {
      _continue(_emailController.text);
    } else {
      final snackBar =
          SnackBar(content: Text("Please provide a valid email/phone"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _continue(data) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{'email': data},
        ),
        'auth/check-email');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonData['role'] == 'customer') {
        _store.save('me', jsonData['id']);
        _isLoading = false;
        if (jsonData['status'] == 'email') {
          Navigator.pushReplacement(context, SlideRightRoute(page: Password()));
        } else {
          Navigator.pushReplacement(
              context,
              SlideRightRoute(
                  page: Verify(phone: "+1" + _emailController.text)));
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _errorSnackbari(
            "The email/phone is not belongs to a customer account!");
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _errorSnackbari(jsonDecode(response.body));
    }
  }

  _errorSnackbari(err) {
    final snackBar = SnackBar(content: Text("$err"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /* _socialLogin(provider) {
     Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => SocialLogin(provider: provider),
        ))
        .then((value) => {
              //
            });
  } */
}
