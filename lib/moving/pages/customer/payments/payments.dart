import 'package:customer/moving/moving_menu.dart';
import 'package:customer/moving/pages/customer/payments/history.dart';
import 'package:customer/moving/pages/customer/payments/method.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(text: "Methodes"),
    Tab(text: "History"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        title: _buildLogo(context),
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
        bottom: TabBar(
          tabs: list,
          controller: _controller,
          indicatorColor: Colors.white,
        ),
      ),
      drawer: MovingMenu(),
      body: TabBarView(
        controller: _controller,
        children: [
          Padding(padding: const EdgeInsets.all(20.0), child: Methods()),
          Padding(padding: const EdgeInsets.all(20.0), child: History()),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: list.length, vsync: this);
    _controller!.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
    });
  }

  SizedBox _buildLogo(context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Image(
        image: AssetImage("assets/images/logo_white.png"),
      ),
    );
  }
}
