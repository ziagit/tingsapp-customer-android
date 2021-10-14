import 'package:customer/moving/pages/order/moving_types.dart';
import 'package:customer/moving/pages/tracking/tracking.dart';
import 'package:customer/shared/public/about.dart';
import 'package:customer/shared/public/cities.dart';
import 'package:flutter/material.dart';
import 'package:customer/shared/public/loading.dart';
import 'package:customer/shared/public/home.dart';

import 'package:customer/moving/pages/customer/acount.dart';
import 'package:customer/moving/pages/customer/payments/payments.dart';
import 'package:customer/moving/pages/customer/order_details.dart';
import 'package:customer/moving/pages/customer/orders.dart';
import 'package:customer/moving/pages/customer/profile.dart';
//moving
import 'package:customer/moving/pages/order/moving.dart';
//shared
import 'package:customer/shared/auth/signin.dart';
import 'package:customer/shared/auth/signup.dart';
import 'package:customer/shared/auth/welcome.dart';
//shapping

import 'package:customer/shared/public/help.dart';
import 'package:customer/shared/public/how_works.dart';
import 'package:customer/shared/public/privacy.dart';
import 'package:customer/shared/public/terms.dart';

void main() => {
      runApp(
        MaterialApp(
          builder: (context, child) => MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Open Sans'),
          initialRoute: '/',
          routes: {
            '/': (_) => Loading(),
            '/home': (_) => Home(),
            '/help': (_) => Help(),
            '/cities': (_) => Cities(),
            '/about': (_) => About(),
            '/how-works': (_) => HowWorks(),
            '/terms': (_) => Terms(),
            '/privacy': (_) => Privacy(),
            '/signin': (_) => Signin(),
            '/signup': (_) => Signup(),
            '/welcome': (_) => Welcome(),
            '/tracking': (_) => Tracking(),
            '/moving': (_) => Moving(),
            '/moving-types': (_) => MovingTypes(),
            '/acount': (_) => Acount(),
            '/profile': (_) => Profile(),
            '/orders': (_) => Orders(),
            '/order-details': (_) => OrderDetails(),
            '/payments': (_) => Payments(),
          },
        ),
      ),
    };
