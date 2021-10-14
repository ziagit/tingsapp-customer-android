import 'package:customer/moving/pages/order/floors.dart';
import 'package:customer/moving/pages/order/moving_time.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/custom_title.dart';
import 'package:customer/shared/components/error_message.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/components/progress.dart';
import 'package:customer/shared/services/store.dart';
import 'package:table_calendar/table_calendar.dart';

class MovingDate extends StatefulWidget {
  @override
  _MovingDateState createState() => _MovingDateState();
}

class _MovingDateState extends State<MovingDate> {
  Store store = Store();
  DateTime _now = DateTime.now();
  DateTime? _selectedDay;
  String? _errorMsg;
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Padding(
        padding: EdgeInsets.only(top: 0, left: 8, right: 8),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            CustomAppbar(),
            Container(child: Progress(progress: 80.0)),
            CustomTitle(title: "When should your items be picked up?"),
            Visibility(
                visible: _errorMsg != null,
                child: ErrorMessage(msg: "Please select a date")),
            FutureBuilder(
              future: _calculation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TableCalendar(
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon:
                          Icon(Icons.arrow_back_ios, color: primary, size: 16),
                      rightChevronIcon: Icon(Icons.arrow_forward_ios,
                          color: primary, size: 16),
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    firstDay: _now,
                    lastDay: DateTime.utc(2050, 12, 1),
                    focusedDay: DateTime.now(),
                    onDaySelected: _onDaySelected,
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: 1,
              onPressed: () => _back(context),
              child: Icon(Icons.arrow_back, color: primary),
            ),
            FloatingActionButton(
              backgroundColor: primary,
              heroTag: 2,
              onPressed: () => _next(context),
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  _back(context) {
    Navigator.pushReplacement(context, SlideLeftRoute(page: Floors()));
  }

  _next(context) async {
    await store.save('moving-date', _selectedDay.toString());
    if (_selectedDay == null) {
      setState(() {
        _errorMsg = "Please select a date";
      });
    } else {
      Navigator.pushReplacement(context, SlideRightRoute(page: MovingTime()));
    }
  }

  _init() async {
    var data = await store.read('moving-date');
    if (data != null) {
      setState(() {
        _selectedDay = DateTime.parse(data);
      });
    }
  }
}
