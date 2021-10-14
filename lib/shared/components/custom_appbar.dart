import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/public/home.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: _iconStyle(context),
              child: Icon(Icons.menu, color: fontColor),
            ),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: _logoStyle(context),
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image(image: AssetImage("assets/images/logo.png"))),
            ),
            onTap: () {
              //
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: _iconStyle(context),
              child: Icon(Icons.home_outlined, color: fontColor),
            ),
            onTap: () {
              Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
            },
          ),
        ],
      ),
    );
  }

  Decoration _iconStyle(context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        new BoxShadow(
          color: Colors.black45,
          offset: new Offset(0.0, 2.0),
          blurRadius: 10.0,
          spreadRadius: 0.1,
        )
      ],
    );
  }

  Decoration _logoStyle(context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(50.0),
    );
  }
}
