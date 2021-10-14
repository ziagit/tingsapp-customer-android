import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer/shared/components/placePredictions.dart';
import 'package:customer/shared/components/divider.dart';
import 'package:customer/shared/components/prediction_tile.dart';
import 'package:customer/shared/services/settings.dart';

class GoogleAddress extends StatefulWidget {
  final selectedAddress;
  final keyword;
  GoogleAddress({Key? key, this.selectedAddress, this.keyword})
      : super(key: key);
  @override
  _GoogleAddressState createState() => _GoogleAddressState();
}

class _GoogleAddressState extends State<GoogleAddress> {
  TextEditingController _addressController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          autofocus: true,
          controller: _addressController,
          decoration: InputDecoration(
            hintText: 'Postal code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          onChanged: (val) {
            findPlace(val);
          },
        ),
        (placePredictionList.length > 0)
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return PredictionTile(
                      placePredictions: placePredictionList[index],
                      callback: (val) {
                        widget.selectedAddress(val);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, index) =>
                      DividerWidget(),
                  itemCount: placePredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              )
            : Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.keyword);
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoComplete =
          "$googleApi?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ca";
      var res = await http.get(Uri.parse(autoComplete));
      Map data = jsonDecode(res.body);
      var predictions = data['predictions'];
      var placesList = (predictions as List)
          .map((e) => PlacePredictions.fromJson(e))
          .toList();
      setState(() {
        placePredictionList = placesList;
      });
    }
  }
}
