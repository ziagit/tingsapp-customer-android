import 'dart:convert';
import 'package:customer/moving/models/user.dart';
import 'package:customer/moving/pages/customer/profile.dart';
import 'package:customer/shared/auth/forget_password.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/input_decoration2.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  final userId;
  const Password({Key? key, this.userId}) : super(key: key);
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  Store store = Store();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(
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
                          controller: _passwordController,
                          decoration: inputDecoration2(context, 'Password'),
                          validator: (value) {
                            if (value == null) {
                              return 'Invalid password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 26.0),
                      _isLoading
                          ? CircularProgressIndicator(color: primary)
                          : SizedBox(
                              width: double.infinity,
                              height: 60.0,
                              child: ElevatedButton(
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          primary!),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _login(context);
                                  }
                                },
                              ),
                            ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                            onPressed: () {
                              _reset();
                            },
                            child: Text("Reset your password")),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      // child: Text("This is where your content goes")
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _login(context) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var me = await store.read('me');
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{"password": _passwordController.text, 'me': me},
        ),
        'auth/signin');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await store.save('token', jsonData);
      var me = await api.get('auth/me');
      if (me.statusCode == 200) {
        var jsonUser = jsonDecode(me.body);
        User u = User(jsonUser['id'], jsonUser['avatar'], jsonUser['name'],
            jsonUser['email'], jsonUser['phone'], '', '');
        await store.save('user', u);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(context, SlideRightRoute(page: Profile()));
    } else {
      setState(() {
        _isLoading = false;
      });
      final snackBar = SnackBar(content: Text("${response.body}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _reset() {
    Navigator.push(context, SlideRightRoute(page: ForgetPassword()))
        .then((value) {
      if (value != null) {
        //
      }
    });
  }
}
