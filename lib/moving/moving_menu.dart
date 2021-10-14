import 'dart:convert';

import 'package:customer/moving/pages/tracking/tracking.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/public/home.dart';
import 'package:flutter/material.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/store.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:progress_indicators/progress_indicators.dart';

class MovingMenu extends StatefulWidget {
  @override
  _MovingMenuState createState() => _MovingMenuState();
}

class _MovingMenuState extends State<MovingMenu> {
  Store _store = Store();
  String? _name;
  String? _phone;
  bool _isLogedIn = false;
  bool _isLogingout = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _isLogedIn
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 80.0,
                          height: 80.0,
                          margin: EdgeInsets.only(top: 30.0),
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: primary,
                            child: Text(
                              "${_name != null ? _name!.substring(0, 2).toUpperCase() : 'TA'}",
                              style: TextStyle(
                                  fontSize: 26.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "$_name",
                              style: TextStyle(fontSize: 22.0),
                            ),
                            Text(
                              "$_phone",
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "MENU",
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: fontColor),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close,
                                      size: 40, color: primary))
                            ],
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  ),
                ),
          _isLogedIn
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primary!),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Let's move",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text(
                        "My moves",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/orders');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text(
                        "Profile",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.credit_card_outlined),
                      title: Text(
                        "Payments",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/payments');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.privacy_tip_outlined),
                      title: Text(
                        "Tracking",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      onTap: () {
                        _track(context, '/tracking');
                      },
                    ),
                    Divider(),
                    _isLogingout
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Text(
                                  "Loging out",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                JumpingDotsProgressIndicator(fontSize: 20.0),
                              ])
                        : ListTile(
                            leading: Icon(Icons.arrow_back),
                            title: Text(
                              "Logout",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            onTap: () {
                              _logout(context);
                            },
                          ),
                    SizedBox(
                      height: 400,
                    )
                  ],
                )
              : Column(
                  children: [
                    ListTile(
                      title: Text(
                        "What is TingsApp?",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                    ListTile(
                      title: Text(
                        "How it works",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/how-works');
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Support",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/help');
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Terms",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/terms');
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Privacy",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/privacy');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Divider(),
                    ),
                    ListTile(
                      title: Text(
                        "My account",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: primary),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/signin');
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _getMe();
    super.initState();
  }

  _logout(context) async {
    setState(() {
      _isLogingout = true;
    });
    Api api = new Api();
    String token = await _store.read('token');
    if (token != null) {
      var response = await api.logout('auth/signout');
      if (response.statusCode == 200) {
        await _store.clear();
        setState(() {
          _isLogingout = false;
        });
        Navigator.pop(context);
        Navigator.pushReplacement(context, SlideLeftRoute(page: Home()));
      } else {
        await _store.remove('token');
        final snackBar = SnackBar(
            content: Text(
          jsonDecode(response.body),
          style: TextStyle(color: Colors.red),
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      print("You already logedout!");
    }
  }

  _getMe() async {
    Api api = new Api();
    var user = await _store.read('user');
    if (user != null) {
      setState(() {
        _name = user['name'];
        _phone = user['phone'];
        _isLogedIn = true;
      });
      return;
    }
    if (await _store.read('token') != null) {
      var data = await api.get('auth/me');
      if (data.statusCode == 200) {
        var me = jsonDecode(data.body);
        setState(() {
          _name = me['name'];
          _phone = me['phone'];
        });
        await _store.save('user',
            {'name': me['name'], 'phone': me['phone'], 'email': me['email']});
      }
    }
  }

  _track(context, path) {
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context,
        SlideRightRoute(
            page: Tracking(
          trackingNumber: '',
        )));
  }
}
