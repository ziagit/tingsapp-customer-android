import 'dart:convert';

import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  //Add this key like this:
  final query;
  const Search({Key? key, this.query}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String _notFound = 'undefined';
  @override
  @override
  void initState() {
    super.initState();
    _searchQueryController.text = widget.query;
  }

  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Stack(
          children: [
            _isSearching
                ? CircularProgressIndicator(color: primary)
                : TextField(
                    controller: _searchQueryController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Enter tracking number",
                      border: InputBorder.none,
                      hintStyle: TextStyle(),
                    ),
                    style: TextStyle(fontSize: 16.0),
                  ),
            Visibility(
              visible: _notFound != 'undefined',
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "$_notFound",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text("Search"),
                onPressed: () {
                  _search(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

//search the order base on it's uniqid
  _search(context) async {
    if (_searchQueryController.text.length == 0) {
      setState(() {
        _notFound = "Please enter a valid tracking number!";
      });
      return;
    }
    setState(() {
      _isSearching = true;
    });
    Api api = new Api();
    var response = await api.post(
        jsonEncode(<String, dynamic>{'key': _searchQueryController.text}),
        'shipper/orders/search');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.length > 0) {
        int mover = data['job_with_carrier']['carrier_detail']['user']['id'];
        var address = data['addresses'];
        setState(() {
          _isSearching = false;
        });
        Navigator.pop(context, {'mover': mover, 'address': address});
      } else {
        setState(() {
          _isSearching = false;
          _notFound = "This order does not exist, check your tracking number!";
        });
      }
    } else {
      setState(() {
        _isSearching = false;
        _notFound = "There is something wrong, please check again!";
      });
    }
  }
}
