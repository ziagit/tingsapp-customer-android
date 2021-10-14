import 'package:customer/moving/pages/order/map.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 40),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                          height: 80,
                          width: 80,
                          child: Image(
                              image: AssetImage("assets/images/logo.png"))),
                      SizedBox(height: 10),
                      Text(
                        "tingsapp",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 60.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primary!),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Let's get you moved",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context, SlideRightRoute(page: GMap()));
                          },
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        "Up front price, Insured. No signup needed",
                      ),
                      SizedBox(height: 80)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String? text;
  final int? selectedPage;
  final int? pageNumber;
  final VoidCallback? onPressed;
  TabButton({this.text, this.selectedPage, this.pageNumber, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
            color: selectedPage == pageNumber
                ? Colors.orange[300]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: Colors.orange[300]!)),
        child: Text(
          text ?? "Tab button",
          style: TextStyle(
              color: selectedPage == pageNumber
                  ? Colors.transparent
                  : Colors.orange[300]),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Let's get you moved", style: TextStyle(fontSize: 28)),
            Align(
              alignment: Alignment.center,
              child: Text("Book your Movers just like you book your ride."),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Become a partner", style: TextStyle(fontSize: 28)),
          Text("Signup for an account ")
        ],
      ),
    );
  }
}
