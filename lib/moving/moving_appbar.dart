import 'package:flutter/material.dart';
import 'package:customer/shared/services/colors.dart';

class MovingAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  MovingAppBar({
    Key? key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: buildLogo(context),
      centerTitle: true,
      backgroundColor: primary,
      //iconTheme: IconThemeData(color: primary),
      elevation: 0,
      actions: [
        Builder(
          builder: (context) => IconButton(
            color: Colors.white,
            icon: Icon(
              Icons.home_outlined,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ),
      ],
    );
  }

  buildLogo(context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: _logoStyle(context),
      child: SizedBox(
          height: 30,
          width: 30,
          child: Image(image: AssetImage("assets/images/logo.png"))),
    );
  }

  Decoration _logoStyle(context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(50.0),
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
}
