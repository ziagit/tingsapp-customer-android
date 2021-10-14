import 'package:flutter/material.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Progress extends StatefulWidget {
  final double? progress;
  Progress({this.progress});
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    double prgValue = widget.progress ?? 0.0;
    String perce = prgValue.toStringAsFixed(0);
    return Container(
      padding: EdgeInsets.fromLTRB(8, 40, 8, 0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 32,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 1200,
              percent: prgValue / 100,
              center: Text("", style: TextStyle(color: Colors.white)),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: primary,
              backgroundColor: Colors.deepPurpleAccent[50],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Questionnaire",
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  "$perce%",
                  style: TextStyle(color: primary, fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
