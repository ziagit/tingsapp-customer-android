import 'package:customer/moving/pages/order/map.dart';
import 'package:customer/moving/pages/tracking/search.dart';
import 'package:customer/shared/services/settings.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class Tracking extends StatefulWidget {
  final trackingNumber;
  const Tracking({Key? key, this.trackingNumber}) : super(key: key);

  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
//polyline point
  double? _originLatitude, _originLongitude;
  double? _destLatitude, _destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  //firebase realtime db
  final DBRef = FirebaseDatabase.instance.reference();
  //marker
  Marker? marker;
  Circle? circle;
  GoogleMapController? _mapController;

  //search togal for popup
  bool _isLoading = true;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: primary),
            )
          : Stack(
              children: [
                GoogleMap(
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
                  circles: Set.of((circle != null) ? [circle!] : []),
                  onMapCreated: _onMapCreated,
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: IconButton(
                      onPressed: () {
                        _closeMap(context);
                      },
                      icon: Icon(Icons.close, color: primary)),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          _searchDialog(context);
        },
        child: Icon(Icons.track_changes),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
  }

  _searchDialog(context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            return Search(query: widget.trackingNumber);
          },
        ),
      ),
    ).then(
      (value) {
        if (value != null) {
          _initMarkers(value['address']);
          getMoverLocation(value['mover']);
          setState(() {});
        }
      },
    );
  }

//initialized marker and polylines
  _initMarkers(data) {
    _originLatitude = double.parse(data[0]['latitude']);
    _originLongitude = double.parse(data[0]['longitude']);
    _destLatitude = double.parse(data[1]['latitude']);
    _destLongitude = double.parse(data[1]['longitude']);

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "Pickup",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "Destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline(data[0]['formatted_address']);
  }

//polyling functions
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
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
  }

//get lat and lng (mover life location) from firebase
  void getMoverLocation(mover) async {
    DBRef.child(mover.toString()).onValue.listen((event) {
      var newLocation = event.snapshot.value;
      if (newLocation != null) {
        double latitude = newLocation['latitude'];
        double longitude = newLocation['longitude'];
        setState(() {
          _isLoading = false;
        });
        _mapController!.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(latitude, longitude),
                tilt: 0,
                zoom: 18.00)));
        _updateMarker(LatLng(latitude, longitude), 'mover');
      }
    });
  }

//make custom marker from asset image
  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/location_map_marker.png");
    return byteData.buffer.asUint8List();
  }

  //_updateMarker() will be called every time mover location change in Firebase
  void _updateMarker(LatLng position, String id) async {
    Uint8List imageData = await getMarker();
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      zIndex: 2,
      icon: BitmapDescriptor.fromBytes(imageData),
      infoWindow: InfoWindow(
        title: "Mover location",
      ),
    );
    this.setState(() {
      markers[markerId] = marker;
      circle = Circle(
        circleId: CircleId("circle"),
        radius: 5,
        zIndex: 1,
        center: position,
        strokeColor: Colors.orange.withAlpha(60),
        fillColor: Colors.orange.withAlpha(200),
      );
    });
  }

  _closeMap(context) {
    Navigator.pushReplacement(context, SlideLeftRoute(page: GMap()));
  }
}
