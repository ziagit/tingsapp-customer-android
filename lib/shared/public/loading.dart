import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:customer/shared/services/colors.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String name = 'Loading';

  void getCards() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void initState() {
    super.initState();
    getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
                height: 80,
                width: 80,
                child: Image(image: AssetImage("assets/images/logo.png"))),
          ),
          Center(child: CircularProgressIndicator(color: primary))
        ],
      ),
    );
  }
}
