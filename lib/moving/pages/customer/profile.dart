import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:customer/moving/models/customer.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/components/google_address.dart';
import 'package:customer/shared/components/slide_top_route.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/store.dart';
import 'package:customer/shared/services/settings.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Store store = Store();
  Customer? _customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
              child: CustomAppbar(),
            ),
            FutureBuilder(
              future: _get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(10.0),
                      decoration: cardDecoration(context),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Customer Profile Details",
                                    style: TextStyle(
                                        color: primary, fontSize: 18.0)),
                              ),
                              SizedBox(height: 10),
                              Row(children: [
                                SizedBox(
                                    width: 100, child: Text("First name: ")),
                                Expanded(
                                    child: Text("${_customer!.first_name}")),
                              ]),
                              Row(children: [
                                SizedBox(
                                    width: 100, child: Text("Last name: ")),
                                Expanded(
                                    child: Text("${_customer!.last_name}")),
                              ]),
                              Row(children: [
                                SizedBox(width: 100, child: Text("Phone: ")),
                                Text("${_customer!.phone}"),
                              ]),
                              Row(children: [
                                SizedBox(width: 100, child: Text("Email: ")),
                                Expanded(child: Text("${_customer!.email}")),
                              ]),
                              Row(children: [
                                SizedBox(width: 100, child: Text("Address: ")),
                                Expanded(child: Text("${_customer!.address}")),
                              ]),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _edit();
                              },
                            ),
                          )
                        ],
                      ));
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
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future _get() async {
    Api api = new Api();
    var response = await api.get('shipper/details');
    var data = jsonDecode(response.body);
    if (response.statusCode == 200 && data.length != 0) {
      _customer = new Customer(
          data['id'],
          data['first_name'],
          data['last_name'],
          data['user']['phone'],
          data['user']['email'],
          data['address']['formatted_address'],
          data['address']['country'],
          data['address']['state'],
          data['address']['city'],
          data['address']['zip'],
          data['address']['id']);
      return _customer;
    } else {
      _add();
    }
  }

  _add() {
    Navigator.push(
      context,
      SlideTopRoute(
        page: Add(),
      ),
    ).then((value) => {
          if (value != null)
            {
              setState(() {}),
            }
        });
  }

  _edit() {
    Navigator.push(
      context,
      SlideTopRoute(
        page: Edit(customer: _customer),
      ),
    ).then((value) => {
          if (value != null)
            {
              setState(() {}),
            }
        });
  }
}

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  Store store = Store();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _zipController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  Store _store = new Store();
  var _user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Details"),
        elevation: 0,
        backgroundColor: primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _user == null
            ? Container(child: Text("Loading..."))
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First name',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        style: TextStyle(fontSize: 12.0),
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Flexible(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last name',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        style: TextStyle(fontSize: 12.0),
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _user['email'] == null
                        ? Flexible(
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 12.0),
                              validator: (value) {
                                if (value == null) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          )
                        : Flexible(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 12.0),
                              validator: (value) {
                                if (value == null) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                    SizedBox(height: 20.0),
                    Flexible(
                      child: TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        style: TextStyle(fontSize: 12.0),
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          }
                          return null;
                        },
                        onChanged: (keyword) {
                          _openDialog(context, keyword);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: _isSubmitting
          ? CircularProgressIndicator()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _save();
                }
              },
            ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    var user = await _store.read('user');
    setState(() {
      _user = user;
    });
  }

  _save() async {
    Api api = new Api();
    setState(() {
      _isSubmitting = true;
    });
    var response = await api.post(
        jsonEncode(<String, dynamic>{
          "first_name": _firstNameController.text,
          "last_name": _lastNameController.text,
          "country": _countryController.text,
          "state": _stateController.text,
          "city": _cityController.text,
          "zip": _zipController.text,
          "formatted_address": _addressController.text,
          "phone": _phoneController.text
        }),
        'shipper/details');
    var jsonData = jsonDecode(response.body);
    setState(() {
      _isSubmitting = false;
    });
    if (response.statusCode != 200) {
      final snackBar = SnackBar(content: Text(jsonData['error'].toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pop(context, 'ok');
    }
  }

  //open google address popup
  void _openDialog(context, keyword) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
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
      (value) {
        print(value);
      },
    );
  }

//select an address from popup
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
      setState(() {
        for (var component in data['result']['address_components']) {
          var types = component['types'];
          if (types.indexOf("locality") > -1) {
            _cityController.text = component['long_name'];
          }
          if (types.indexOf("administrative_area_level_1") > -1) {
            _stateController.text = component['short_name'];
          }
          if (types.indexOf("postal_code") > -1) {
            _zipController.text = component['long_name'];
          }
          if (types.indexOf("country") > -1) {
            _countryController.text = component['long_name'];
          }
        }
        _addressController.text = data['result']['formatted_address'];
      });
    }
  }
  //end

}

class Edit extends StatefulWidget {
  final customer;
  Edit({Key? key, this.customer}) : super(key: key);
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  Store store = Store();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _zipController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Details",
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Flexible(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Flexible(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Flexible(
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Flexible(
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Flexible(
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  onChanged: (keyword) {
                    _openDialog(context, keyword);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isSubmitting
          ? CircularProgressIndicator(color: primary)
          : FloatingActionButton(
              backgroundColor: primary,
              child: Icon(Icons.edit),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _update();
                }
              },
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    print(widget.customer);
    _init();
  }

  _init() {
    setState(() {
      _firstNameController.text = widget.customer.first_name;
      _lastNameController.text = widget.customer.last_name;
      _phoneController.text = widget.customer.phone;
      _emailController.text = widget.customer.email;
      _addressController.text = widget.customer.address;
      _countryController.text = widget.customer.country;
      _stateController.text = widget.customer.state;
      _cityController.text = widget.customer.city;
      _zipController.text = widget.customer.zip;
    });
  }

  _update() async {
    Api api = new Api();
    setState(() {
      _isSubmitting = true;
    });
    var response = await api.update(
        jsonEncode(<String, dynamic>{
          "first_name": _firstNameController.text,
          "last_name": _lastNameController.text,
          "phone": _phoneController.text,
          "email": _emailController.text,
          "country": _countryController.text,
          "state": _stateController.text,
          "city": _cityController.text,
          "zip": _zipController.text,
          "formatted_address": _addressController.text,
          "addressId": widget.customer.address_id,
        }),
        "shipper/details/${widget.customer.id}");
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isSubmitting = false;
      });
      Navigator.pop(context, 'ok');
    } else {
      final snackBar = SnackBar(content: Text(jsonData['error'].toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  //open google address popup
  void _openDialog(context, keyword) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
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
      (value) {
        print(value);
      },
    );
  }

//select an address from popup
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
      setState(() {
        for (var component in data['result']['address_components']) {
          var types = component['types'];
          if (types.indexOf("locality") > -1) {
            _cityController.text = component['long_name'];
          }
          if (types.indexOf("administrative_area_level_1") > -1) {
            _stateController.text = component['short_name'];
          }
          if (types.indexOf("postal_code") > -1) {
            _zipController.text = component['long_name'];
          }
          if (types.indexOf("country") > -1) {
            _countryController.text = component['long_name'];
          }
        }
        _addressController.text = data['result']['formatted_address'];
      });
    }
  }
  //end

}
