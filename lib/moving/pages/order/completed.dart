import 'package:customer/moving/pages/tracking/tracking.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/services/colors.dart';

class Completed extends StatelessWidget {
  final order;
  Completed({this.order});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 0, left: 8, right: 8),
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomAppbar(),
            Column(
              children: [
                SizedBox(height: 80),
                Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline_outlined,
                      size: 80,
                      color: primary,
                    ),
                    Text(
                      "Your booking was successfull",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Thank you for choosing us!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: fontColor),
                    ),
                  ],
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 80, left: 8, right: 8, bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: cardDecoration(context),
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent[50],
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(color: primary!),
                          ),
                          child: Icon(Icons.timeline_outlined,
                              color: primary, size: 40)),
                      Text(
                          "$order is your order number, you can track your order/mover untill order completion.",
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text("Book another move",
                          style: TextStyle(color: primary)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            SlideRightRoute(
                                page: Tracking(trackingNumber: order)));
                      },
                      child: Text("Track", style: TextStyle(color: primary)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
