import 'package:customer/shared/services/api.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:customer/moving/models/from_address_model.dart';
import 'package:customer/shared/components/google_address.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';
import 'package:customer/shared/services/settings.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class From extends StatefulWidget {
  final myCallback;
  From({Key? key, this.myCallback}) : super(key: key);
  @override
  _FromState createState() => _FromState();
}

class _FromState extends State<From> {
  Location _locationTracker = Location();
  Store _store = Store();
  List? types;
  TextEditingController _addressController = TextEditingController();

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
  var _from;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Pickup',
            border: OutlineInputBorder(),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              onPressed: () {
                _getCurrentLocation(context);
              },
              icon: Transform.rotate(
                angle: -math.pi / 4,
                child: Icon(Icons.send),
              ),
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
              return 'Required';
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

  void _openDialog(context, keyword) {
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
                onPressed: () => Navigator.of(context).pop()),
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
  }

  _init() async {
    _from = await _store.read('from');
    if (_from != null) {
      setState(() {
        country = _from['country'];
        state = _from['state'];
        city = _from['city'];
        zip = _from['zip'];
        street = _from['street'];
        street_number = _from['street_number'];
        formatted_address = _from['formatted_address'];
        latitude = _checkString(_from['latitude']);
        longitude = _checkString(_from['longitude']);
        _addressController.text = _from['formatted_address'];
      });
    }
  }

  _checkString(data) {
    if (data is String) {
      return double.parse(data);
    }
    return data;
  }

//select an address
  selected(selectedAddress) {
    if (selectedAddress.description != null) {
      setState(() {
        _addressController.text = selectedAddress.description;
        addressDetails(selectedAddress.place_id);
      });
    }
  }

//get place id and send new req to google for add details
  addressDetails(placeId) async {
    Api api = new Api();
    String placeDetailsUrl = "$googleDetails?place_id=$placeId&key=$mapKey";
    var res = await api.googleAddressDetails(placeDetailsUrl);
    if (res.statusCode == 200) {
      Map data = jsonDecode(res.body);
      _initAddress(data['result']);
    } else {
      final snackBar = SnackBar(
          content: Text(
        jsonDecode(res.body),
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    //send data to parent
  }

  //get current location in case user clicked on location icon
  void _getCurrentLocation(context) async {
    try {
      var location = await _locationTracker.getLocation();
      _getAddressFromLatLng(location.latitude, location.longitude);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  _getAddressFromLatLng(double lat, double lng) async {
    Api api = new Api();
    if (lat != null && lng != null) {
      var response = await api.getAddressFromLatLng(lat, lng);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        _addressController.text = data['results'][0]['formatted_address'];
        _initAddress(data['results'][0]);
      } else {
        final snackBar = SnackBar(
            content: Text(
          jsonDecode(response.body),
          style: TextStyle(color: Colors.red),
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    } else
      return null;
  }

  _initAddress(address) async {
    FromAddressModel fromAddressModel = FromAddressModel();
    for (var component in address['address_components']) {
      var types = component['types'];
      if (types.indexOf("street_number") > -1) {
        fromAddressModel.street_number = component['long_name'];
      }
      if (types.indexOf("route") > -1) {
        fromAddressModel.street = component['long_name'];
      }
      if (types.indexOf("locality") > -1) {
        fromAddressModel.city = component['long_name'];
      }
      if (types.indexOf("administrative_area_level_1") > -1) {
        fromAddressModel.state = component['short_name'];
      }
      if (types.indexOf("postal_code") > -1) {
        fromAddressModel.zip = component['long_name'];
      }
      if (types.indexOf("country") > -1) {
        fromAddressModel.country = component['long_name'];
      }
    }
    fromAddressModel.formatted_address = address['formatted_address'];
    fromAddressModel.latitude = address['geometry']['location']['lat'];
    fromAddressModel.longitude = address['geometry']['location']['lng'];
    await _store.save('from', fromAddressModel);
    if (_from == null) {
      widget.myCallback(fromAddressModel, 'init');
    } else {
      widget.myCallback(fromAddressModel, 'update');
    }
  }
}
