import 'package:http/http.dart' as http;
import 'package:customer/shared/services/store.dart';
import 'package:customer/shared/services/settings.dart';

class Api {
  Store _store = Store();
  Future<String> getStripeKey() async {
    return stripKey;
    /*   try {
      var response = await http.get(
        Uri.parse('$baseUrl' + "auth/stripe-key"),
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    } */
  }

  Future<http.Response> getGoogleProfile() async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl' + "auth/google"),
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> getFacebookProfile(token) async {
    try {
      var response = await http.get(Uri.parse(facebookUrl + token));
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> get(path) async {
    String token = await _store.read('token');
    try {
      var response = await http.get(Uri.parse('$baseUrl$path'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> post(data, path) async {
    String token = await _store.read('token');
    try {
      var response = await http.post(Uri.parse(baseUrl + path),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: data);
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> update(data, path) async {
    String token = await _store.read('token');
    try {
      var response = await http.put(Uri.parse('$baseUrl$path'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: data);
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> logout(path) async {
    String token = await _store.read('token');
    try {
      var response = await http.post(Uri.parse('$baseUrl' + path), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      });
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> getGoogleMapDestance(from, to) async {
    try {
      var response = await http.get(Uri.parse(
          "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$from&destinations=$to&mode=driving&language=en-EN&key=$mapKey"));
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> getAddressFromLatLng(lat, lng) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$mapKey&language=en&latlng=$lat,$lng';
    try {
      var response = await http.get(Uri.parse(url));
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }

  Future<http.Response> googleAddressDetails(path) async {
    try {
      var response = await http.get(Uri.parse('$path'));
      return response;
    } catch (err) {
      return http.Response('${err.toString()}', 400);
    }
  }
}
