import 'package:customer/moving/pages/customer/profile.dart';
import 'package:customer/shared/auth/verify.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_top_route.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  Store _store = Store();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _terms = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
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
                  child: CircleAvatar(
                    radius: 25.0,
                    child: Text(
                      "T",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: primary,
                  ),
                  decoration: BoxDecoration(),
                ),
                SizedBox(height: 20.0),
                Text(
                  "SignUp",
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(height: 26.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Name'),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a valid name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Email/phone'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Password'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Password confirmation'),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _terms,
                            onChanged: _handleTerms,
                            activeColor: primary,
                          ),
                          Text("I accept the terms and use")
                        ],
                      ),
                      SizedBox(height: 20.0),
                      _isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              height: 46.0,
                              child: ElevatedButton(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      _terms) {
                                    _register(context);
                                  } else {
                                    final snackBar = SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text("Provide valid data!"));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                              ),
                            ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signin');
                          },
                          child: Text(
                            'Signin',
                            style: TextStyle(color: primary, fontSize: 12.0),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      // child: Text("This is where your content goes")
    );
  }

  _handleTerms(value) {
    setState(() {
      _terms = value;
    });
  }

  void _register(context) async {
    Api api = new Api();
    if (_passwordController.text != _confirmPasswordController.text) {
      final snackBar = SnackBar(
          content: Text(
        "Passwords not match!",
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(<String, dynamic>{
          "name": _nameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "password_confirmation": _confirmPasswordController.text,
          "type": 'customer',
        }),
        "auth/verify-email");
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _store.save('me', jsonData);
      setState(() {
        _isLoading = false;
      });
      Navigator.push(context, SlideTopRoute(page: Verify())).then((value) => {
            if (value != null)
              {
                Navigator.pushReplacement(
                    context, SlideLeftRoute(page: Profile()))
              }
          });
    } else {
      setState(() {
        _isLoading = false;
      });
      final snackBar =
          SnackBar(backgroundColor: Colors.red, content: Text(jsonDecode(response.body)));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
