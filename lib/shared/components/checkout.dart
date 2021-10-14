import 'dart:convert';

import 'package:customer/shared/components/google_address.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:customer/shared/services/settings.dart';
import 'package:customer/shared/services/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:email_validator/email_validator.dart';

class Checkout extends StatefulWidget {
  final status;
  Checkout({this.status});
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameOnCardController = new TextEditingController();
  TextEditingController _cardNumberController = new TextEditingController();
  TextEditingController _cvcController = new TextEditingController();
  TextEditingController _expYearController = new TextEditingController();
  TextEditingController _expMonthController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _zipController = new TextEditingController();
  TextEditingController _stateController = new TextEditingController();
  String _stripeError = 'undefined';
  bool _isProfileAddress = false;
  bool _isSubmitting = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  Store _store = new Store();

  Future _getStripeKey() async {
    Api api = new Api();
    var response = await api.getStripeKey();
    StripePayment.setOptions(
      StripeOptions(
          publishableKey: response, merchantId: "Test", androidPayMode: 'test'),
    );
    return response;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primary),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: FutureBuilder(
          future: _getStripeKey(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    widget.status == 'edit'
                        ? CheckboxListTile(
                            activeColor: primary,
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              "Is your billing address same as your profile address?",
                              style: TextStyle(fontSize: 11),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _isProfileAddress,
                            onChanged: (value) {
                              _getAddress(context, value);
                              setState(() {
                                _isProfileAddress = value!;
                              });
                            },
                          )
                        : Container(),
                    Visibility(
                      visible: _isLoading,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    _stripeError == 'undefined'
                        ? Container()
                        : SizedBox(
                            height: 20,
                            child: Text(
                              _stripeError,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                    TextFormField(
                      autofocus: true,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 12.0),
                      validator: (value) {
                        if (value != null) {
                          return 'Invalid name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      autofocus: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 12.0),
                      validator: (value) {
                        if (value != null) {
                          return 'Not valid email!';
                        }
                        if (!isEmailValid(_emailController.text)) {
                          return 'Not valid email!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 12.0),
                      validator: (value) {
                        if (value != null) {
                          return 'Required!';
                        }
                        return null;
                      },
                      onChanged: (keyword) {
                        _openDialog2(context, keyword);
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _countryController,
                            decoration: InputDecoration(
                              labelText: 'Country',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 12.0),
                            validator: (value) {
                              if (value != null) {
                                return 'Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _stateController,
                            decoration: InputDecoration(
                              labelText: 'State',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 12.0),
                            validator: (value) {
                              if (value != null) {
                                return 'Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 12.0),
                            validator: (value) {
                              if (value != null) {
                                return 'Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _zipController,
                            decoration: InputDecoration(
                              labelText: 'Postalcode',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 12.0),
                            validator: (value) {
                              if (value != null) {
                                return 'Required!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nameOnCardController,
                      decoration: InputDecoration(
                        labelText: 'Name on card',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 12.0),
                      validator: (value) {
                        if (value != null) {
                          return 'Required!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(16)],
                      decoration: InputDecoration(
                        labelText: 'Card number',
                        prefixIcon: Icon(Icons.credit_card),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 12.0),
                      validator: (value) {
                        if (value != null) {
                          return 'Card number is invalid!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _cvcController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3)
                            ],
                            decoration: InputDecoration(
                              labelText: 'CVC',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 12.0),
                            validator: (value) {
                              if (value != null) {
                                return 'Enter a 3 digits number';
                              }
                              return null;
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _expMonthController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2)
                            ],
                            decoration: InputDecoration(
                              labelText: 'Exp month',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  bottomLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 12.0),
                            validator: (value) {
                              if (value != null) {
                                return 'Enter a valid 2 ditis month';
                              }
                              return null;
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _expYearController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2)
                            ],
                            decoration: InputDecoration(
                              labelText: 'Exp year',
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 12.0),
                            validator: (value) {
                              if (value != null) {
                                return 'Enter a valid 2 digits year';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
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
        ),
      ),
      floatingActionButton: _isSubmitting
          ? CircularProgressIndicator(color: primary)
          : FloatingActionButton(
              backgroundColor: primary,
              onPressed: () {
                setState(() {
                  _isSubmitting = true;
                });
                _getStripeToken(context);
              },
              child: Icon(Icons.add),
            ),
    );
  }

  bool isEmailValid(email) {
    final bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  //open google address popup
  void _openDialog2(context, keyword) {
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

  _getStripeToken(context) {
    if (_nameController.text.length == 0 ||
        _emailController.text.length == 0 ||
        _addressController.text.length == 0 ||
        _countryController.text.length == 0 ||
        _stateController.text.length == 0 ||
        _cityController.text.length == 0 ||
        _zipController.text.length == 0 ||
        _nameOnCardController.text.length == 0 ||
        _cardNumberController.text.length == 0 ||
        _cvcController.text.length == 0 ||
        _expMonthController.text.length == 0 ||
        _expYearController.text.length == 0) {
      setState(() {
        _isSubmitting = false;
      });
      final snackBar = SnackBar(
          content: Text(
        "Please fill all the fields!",
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final CreditCard shippingCard = CreditCard(
        number: _cardNumberController.text,
        expMonth: int.parse(_expMonthController.text),
        expYear: int.parse(_expYearController.text),
        cvc: _cvcController.text,
      );
      StripePayment.createTokenWithCard(shippingCard).then(
        (token) {
          _createCustomer(context, token.tokenId);
        },
      ).catchError(
        (error) {
          setState(
            () {
              _stripeError = error.message;
              _isSubmitting = false;
            },
          );
        },
      );
    }
  }

  _createCustomer(context, stripeToken) async {
    Api api = new Api();
    var mover = await _store.read('mover');
    var price;
    if (mover != null) {
      price = mover['price'];
    }
    var data = jsonEncode(<String, dynamic>{
      'name': _nameController.text,
      'email': _emailController.text,
      'country': _countryController.text,
      'formatted_address': _addressController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'postalcode': _zipController.text,
      'name_oncard': _nameOnCardController.text,
      'stripeToken': stripeToken,
      'price': price
    });
    await _store.save('contacts', data);
    try {
      var response = await api.post(data, 'shipper/create-customer');
      if (response.statusCode == 200) {
        setState(() {
          _isSubmitting = false;
        });
        Navigator.pop(context, 'ok');
      } else {
        setState(() {
          _isSubmitting = false;
          _stripeError = jsonDecode(response.body);
        });
      }
    } catch (err) {
      print('${err.toString()}');
    }
  }

  _getAddress(context, value) async {
    Api api = new Api();
    if (value == true) {
      setState(() {
        _isLoading = true;
      });
      var response = await api.get('shipper/shipper-address');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _isLoading = false;
          _nameController.text = data['first_name'];
          _emailController.text = data['user']['email'];
          _addressController.text = data['address']['formatted_address'];
          _countryController.text = data['address']['country'];
          _stateController.text = data['address']['state'];
          _cityController.text = data['address']['city'];
          _zipController.text = data['address']['zip'];
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _nameController.text = '';
        _emailController.text = '';
        _addressController.text = '';
        _countryController.text = '';
        _stateController.text = '';
        _cityController.text = '';
        _zipController.text = '';
      });
    }
  }
}
