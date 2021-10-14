import 'package:flutter/material.dart';
import 'package:customer/shared/components/placePredictions.dart';

class PredictionTile extends StatelessWidget {
  final PlacePredictions? placePredictions;
  final callback;

  PredictionTile({Key? key, this.placePredictions, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlaceAddressDetails(placePredictions!, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text(placePredictions!.main_text!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0)),
                      SizedBox(height: 2.0),
                      Text(
                        placePredictions!.secondary_text!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 10.0)
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(
      PlacePredictions placePredictions, context) async {
    callback(placePredictions);
    Navigator.pop(context);
  }
}
