import 'package:flutter/material.dart';
import 'package:customer/moving/models/to_address_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer/shared/components/google_address.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';
import 'package:customer/shared/services/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class To extends StatefulWidget {
  final myCallback;
  To({Key? key, this.myCallback}) : super(key: key);
  @override
  _ToState createState() => _ToState();
}

class _ToState extends State<To> {
  Store _store = Store();
  TextEditingController _addressController = TextEditingController();
  List? types;
  String? country;
  String? state;
  String? city;
  String? zip;
  String? street;
  String? street_number;
  String? formatted_address;
  double? latitude;
  double? longitude;
  final _formKey = GlobalKey<FormState>();
  var _to;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Dropoff',
            border: OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              onPressed: () {
                _infoModal(context);
              },
              icon: Icon(Icons.info_outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          validator: (value) {
            if (value != null) {
              return 'Invalid address';
            }
            return null;
          },
          onChanged: (keyword) {
            _openDialog(context, keyword);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _openDialog(context, keyword) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Center(
                    child: GoogleAddress(
                        selectedAddress: selected, keyword: keyword)),
              ),
            ),
          ),
        );
      },
    );
/*     showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
              height: height - 400,
              width: width - 100,
              child: GoogleAddress(selectedAddress: selected, keyword: keyword),
            );
          },
        ),
      ),
    ).then(
      (value) {},
    ); */
  }

  _init() async {
    _to = await _store.read('to');
    if (_to != null) {
      setState(() {
        country = _to['country'];
        state = _to['state'];
        city = _to['city'];
        zip = _to['zip'];
        street = _to['street'];
        street_number = _to['street_number'];
        formatted_address = _to['formatted_address'];
        latitude = _checkString(_to['latitude']);
        longitude = _checkString(_to['longitude']);
        _addressController.text = _to['formatted_address'];
      });
    }
  }

  _checkString(data) {
    if (data is String) {
      return double.parse(data);
    }
    return data;
  }

  //select an add
  selected(selectedAddress) {
    if (selectedAddress.description != null) {
      setState(() {
        _addressController.text = selectedAddress.description;
        addressDetails(selectedAddress.place_id);
      });
    }
  }

  //get place id from selected and send a req for add details
  addressDetails(placeId) async {
    String placeDetailsUrl = "$googleDetails?place_id=$placeId&key=$mapKey";
    var res = await http.get(Uri.parse(placeDetailsUrl));
    Map data = jsonDecode(res.body);
    ToAddressModel toAddressModel = ToAddressModel();
    for (var component in data['result']['address_components']) {
      var types = component['types'];
      if (types.indexOf("street_number") > -1) {
        toAddressModel.street_number = component['long_name'];
      }
      if (types.indexOf("route") > -1) {
        toAddressModel.street = component['long_name'];
      }
      if (types.indexOf("locality") > -1) {
        toAddressModel.city = component['long_name'];
      }
      if (types.indexOf("administrative_area_level_1") > -1) {
        toAddressModel.state = component['short_name'];
      }
      if (types.indexOf("postal_code") > -1) {
        toAddressModel.zip = component['long_name'];
      }
      if (types.indexOf("country") > -1) {
        toAddressModel.country = component['long_name'];
      }
    }
    toAddressModel.formatted_address = data['result']['formatted_address'];
    toAddressModel.latitude = data['result']['geometry']['location']['lat'];
    toAddressModel.longitude = data['result']['geometry']['location']['lng'];
    await _store.save('to', toAddressModel);
    if (_to == null) {
      widget.myCallback(toAddressModel, 'init');
    } else {
      widget.myCallback(toAddressModel, 'update');
    }
  }

  //modal
  _infoModal(context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            Text(
              "More info:",
              style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text:
                          "- Please select pickup and dropoff location in the same city or metro area, within our ",
                      style: TextStyle(color: fontColor, fontSize: 16)),
                  WidgetSpan(
                    child: GestureDetector(
                      child: Text(
                        'coverage',
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      ),
                      onTap: () {
                        _openLink(context, "https://www.tingsapp.com/cities");
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "- For junk removal, please search a ",
                      style: TextStyle(color: fontColor, fontSize: 16)),
                  WidgetSpan(
                    child: GestureDetector(
                      child: Text(
                        'disposal site near you. ',
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      ),
                      onTap: () {
                        _openLink(context,
                            "https://www.google.com/search?q=disposal+area+near+me&sxsrf=ALeKk01Dmb-Q2xWE4XdTkgQnGnW3j98yog%3A1621308734570&source=hp&ei=PjWjYO6nIOWmrgT_n4zICg&iflsig=AINFCbYAAAAAYKNDTiFu5JE7M2WPkrz60o6SYW8uj_dB&oq=disposal+area+near&gs_lcp=Cgdnd3Mtd2l6EAMYADIFCAAQyQMyBggAEBYQHjIGCAAQFhAeOgQIIxAnOgIIADoCCC46BAgAEEM6CQgjECcQRhD5AToKCC4QxwEQrwEQQzoKCAAQyQMQQxCLAzoHCAAQQxCLAzoECAAQClDqlhRYis0UYPTcFGgAcAB4AYABlwSIAdQnkgELMC41LjguMi4xLjKYAQCgAQGqAQdnd3Mtd2l6uAEC&sclient=gws-wiz&dlnr=1&sei=kzajYJRHg-CSBc6Aj7gO");
                      },
                    ),
                  ),
                  TextSpan(
                      text: "paste their address in destination.",
                      style: TextStyle(color: fontColor, fontSize: 16)),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }

  _openLink(context, link) async {
    await canLaunch(link) ? await launch(link) : throw 'Could not launch $link';
  }
}
