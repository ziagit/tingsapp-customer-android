import 'package:customer/moving/moving_menu.dart';
import 'package:customer/moving/pages/order/from.dart';
import 'package:customer/moving/pages/order/moving_types.dart';
import 'package:customer/moving/pages/order/to.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/custom_title.dart';
import 'package:customer/shared/components/hide_keboard.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/services/settings.dart';
import 'package:customer/shared/services/store.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GMap extends StatefulWidget {
  const GMap({Key? key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  bool? _isLoading = true;

  _refresher() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _refresher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: _isLoading!
          ? Center(child: CircularProgressIndicator(color: primary))
          : Content(
              mapRefreshCallback: (val) {
                print("....................value: $val");
                //_refreshDialog(context);
              },
            ),
    );
  }
}

class Content extends StatefulWidget {
  final mapRefreshCallback;
  const Content({Key? key, this.mapRefreshCallback}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  //polyline point
  double? _originLatitude, _originLongitude;
  double? _destLatitude, _destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  //marker
  Marker? marker;
  GoogleMapController? _mapController;

  var _supportedArea = [];
  Store _store = Store();
  var _from;
  var _to;
  var currentFocus;
  @override
  void initState() {
    super.initState();
    _init();
    _getSupportedAreas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(49.28365819800792, -123.10308363551924),
              zoom: 12.4746,
            ),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: _onMapCreated,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, right: 8, left: 8),
            child: CustomAppbar()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: Text(
                    "Enter pickup and drop off locations",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: cardDecoration(context),
                      padding: EdgeInsets.all(8),
                      child: From(
                        myCallback: (val, status) {
                          if (status == 'init') {
                            _init();
                          } else {
                            _updatePickupMarker(val);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: cardDecoration(context),
                      padding: EdgeInsets.all(8),
                      child: To(myCallback: (val, status) {
                        if (status == 'init') {
                          _init();
                        } else {
                          _updateDestinationMarker(val);
                        }
                      }),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primary!),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Get a price",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      _next(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

//all related to map
  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
  }

//update markers
  _updatePickupMarker(data) {
    hideKeboard(context, currentFocus);
    this.setState(() {
      polylineCoordinates.clear();
      _originLatitude = data.latitude;
      _originLongitude = data.longitude;
    });
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        new CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(data.latitude, data.longitude),
            tilt: 0,
            zoom: 12.00)));
    MarkerId markerId = MarkerId("Pickup");
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(data.latitude, data.longitude),
      infoWindow: InfoWindow(
        title: "Pickup",
      ),
    );
    markers[markerId] = marker;
    if (_to != null) {
      _getNewPolyline(_from['formatted_address']);
    } else {
      setState(() {
        widget.mapRefreshCallback(true);
      });
    }
  }

  _updateDestinationMarker(data) {
    hideKeboard(context, currentFocus);
    setState(() {
      polylineCoordinates.clear();
      _destLatitude = data.latitude;
      _destLongitude = data.longitude;
    });
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        new CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(data.latitude, data.longitude),
            tilt: 0,
            zoom: 12.00)));
    MarkerId markerId = MarkerId("Destination");
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(90),
      position: LatLng(data.latitude, data.longitude),
      infoWindow: InfoWindow(
        title: "Destination",
      ),
    );
    markers[markerId] = marker;
    if (_from != null) {
      _getNewPolyline(data.formatted_address);
    } else {
      setState(() {});
    }
  }

//initialized marker and polylines
  _initPickupMarker(data) {
    hideKeboard(context, currentFocus);
    _originLatitude = data['latitude'];
    _originLongitude = data['longitude'];
    _addMarker(LatLng(_originLatitude, _originLongitude), "Pickup",
        BitmapDescriptor.defaultMarker);
    if (_to != null) {
      _getPolyline(_from['formatted_address']);
    } else {
      setState(() {});
    }
  }

  _initDestinationMarker(data) {
    hideKeboard(context, currentFocus);
    _destLatitude = data['latitude'];
    _destLongitude = data['longitude'];
    _addMarker(LatLng(_destLatitude, _destLongitude), "Destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    if (_from != null) {
      _getPolyline(_from['formatted_address']);
    } else {
      setState(() {});
    }
  }

//add pickup and destination markers
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      infoWindow: InfoWindow(
        title: "$id",
      ),
    );
    markers[markerId] = marker;
    setState(() {});
  }

//get cordinates
  _getPolyline(pickupAddress) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(_originLatitude!, _originLongitude!),
        PointLatLng(_destLatitude!, _destLongitude!),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "$pickupAddress")]);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

//add polyling
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getNewPolyline(pickupAddress) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(_originLatitude!, _originLongitude!),
        PointLatLng(_destLatitude!, _destLongitude!),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "$pickupAddress")]);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _updatePolyLine();
  }

  _updatePolyLine() {
    PolylineId id = PolylineId("poly2");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {
      widget.mapRefreshCallback(true);
    });
  }
  //

  _getSupportedAreas() async {
    Api api = new Api();
    var response = await api.get('state-cities');
    if (response.statusCode == 200) {
      _supportedArea = jsonDecode(response.body);
    } else {
      setState(() {});
      final snackBar = SnackBar(
          content: Text(
        "${response.body}",
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _next(context) async {
    if (_from == null || _to == null) {
      _invalidDialog(context, 'Please provide a valid address!');
      return;
    }
    if (await _checkState(_from) && await _checkCity(_from)) {
      if (await _checkState(_to) && await _checkCity(_to)) {
        Navigator.pushReplacement(
            context,
            SlideRightRoute(
              page: MovingTypes(),
            ));
      } else {
        _invalidDialog(context,
            'The destination location is out of our current service area. We are working on expanding our coverage.');
      }
    } else {
      _invalidDialog(context,
          'The pickup location is out of our current service area. We are working on expanding our coverage.');
    }
  }

  //check state
  _checkState(selected) async {
    for (int i = 0; i < _supportedArea.length; i++) {
      if (this._supportedArea[i]['name'] == selected['state']) {
        return true;
      }
    }
    return false;
  }

  //check city
  _checkCity(selected) async {
    for (int i = 0; i < _supportedArea.length; i++) {
      for (int j = i; j < _supportedArea[i]['cities'].length; j++) {
        if (_supportedArea[i]['cities'][j]['name'] == selected['city']) {
          return true;
        }
      }
    }
    return false;
  }

  _invalidDialog(context, message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Invalid address!'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Stack(
          children: [
            Builder(
              builder: (context) {
                var width = MediaQuery.of(context).size.width;
                return Container(
                  width: width,
                  child: Text(message),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Ok',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    ).then((value) {
      //
    });
  }

//init the map
  _init() async {
    print("initial cordinates......................................");
    print(polylineCoordinates);
    _from = await _store.read('from');
    _to = await _store.read('to');
    _initPickupMarker(_from);
    _initDestinationMarker(_to);
  }
}
