import 'package:flutter/material.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';

import 'package:flutter/cupertino.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Store store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to TingsApp",
                style: TextStyle(
                    color: primary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Please complete your registeration",
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                child: Text(
                  "Continue",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                ),
                onPressed: () {
                  _profile(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //_getMe(context);
  }

/*   _getMe(context) async {
    String _token = await store.read('token');
    try {
      var response = await getMe('moving/auth/me', _token);
      var jsonData = jsonDecode(response.body);
      setState(() {
        _role = jsonData['role'][0]['name'];
      });
      await store.save('role', _role);
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  } */

  _profile(context) async {
    if (await store.read('app') == 'moving') {
      Navigator.pushReplacementNamed(context, '/customer-profile');
    } else {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }
}
