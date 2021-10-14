import 'dart:convert';

import 'package:customer/shared/auth/password.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/input_decoration2.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/functions/email_validator.dart';
import 'package:customer/shared/functions/phone_validator.dart';
import 'package:customer/shared/public/home.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: primary),
      ),
      body: OrientationBuilder(builder: (_, orientation) {
        if (orientation == Orientation.portrait)
          return _buildPortraitLayout(); // if orientation is portrait, show your portrait layout
        else
          return _buildLandscapeLayout(); // else show the landscape one
      }),

      // child: Text("This is where your content goes")
    );
  }

  Padding _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Expanded(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 80,
                      width: 80,
                      child:
                          Image(image: AssetImage("assets/images/logo.png"))),
                  SizedBox(height: 10),
                  Text(
                    "Tingsapp",
                    style: TextStyle(fontSize: 36),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: cardDecoration(context),
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: inputDecoration2(
                          context, 'Enter your email or phone'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  _isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 60.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(primary!),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                            ),
                            child: Text(
                              "Send",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              _send(context);
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: cardDecoration(context),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: inputDecoration2(
                          context, 'Enter your email or phone'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          _isLoading
              ? CircularProgressIndicator(color: primary)
              : SizedBox(
                  height: 66.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primary!),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Send",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      _send(context);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _send(context) async {
    if (isValidPhone(_emailController.text)) {
      String phone = '+1' + _emailController.text;
      _continue(phone);
    } else if (isValidEmail(_emailController.text)) {
      _continue(_emailController.text);
    } else {
      final snackBar =
          SnackBar(content: Text("Please provide a valid email/phone"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _continue(data) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{'email': data},
        ),
        'password/forget');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(context,
              SlideRightRoute(page: ResetPassword(email: jsonData['email'])))
          .then((value) {
        if (value != null) {
          Navigator.push(
                  context, SlideRightRoute(page: NewPassword(email: value)))
              .then((value) {
            Navigator.push(context,
                    SlideRightRoute(page: Password(userId: value.toString())))
                .then((value) {
              if (value != null) {
                Navigator.pushReplacement(
                    context, SlideRightRoute(page: Home()));
              }
            });
          });
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      _errorSnackbar("${jsonDecode(response.body)}");
    }
  }

  _errorSnackbar(err) {
    final snackBar = SnackBar(content: Text("$err"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
// verify

class ResetPassword extends StatefulWidget {
  final email;
  const ResetPassword({Key? key, this.email}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool _isLoading = false;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: primary),
        title: Text("Verify", style: TextStyle(color: primary)),
        centerTitle: true,
      ),
      body: OrientationBuilder(builder: (_, orientation) {
        if (orientation == Orientation.portrait)
          return _buildPortraitLayout(); // if orientation is portrait, show your portrait layout
        else
          return _buildLandscapeLayout(); // else show the landscape one
      }),
    );
  }

  Padding _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 80,
              width: 80,
              child: Image(image: AssetImage("assets/images/logo.png"))),
          SizedBox(height: 10),
          Text(
            "Tings App",
            style: TextStyle(fontSize: 36),
          ),
          SizedBox(height: 16),
          Container(
            child: PinPut(
              fieldsCount: 4,
              onSubmit: (String pin) => _verify(pin, context),
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(20.0),
              ),
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.black38,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "We texted a code to your email/phone",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: _isLoading ? CircularProgressIndicator() : Container()),
        ],
      ),
    );
  }

  Padding _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: PinPut(
              fieldsCount: 4,
              onSubmit: (String pin) => _verify(pin, context),
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(20.0),
              ),
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.black38,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "We texted a code to your email/phone",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              _isLoading ? CircularProgressIndicator() : Container()
            ],
          )
        ],
      ),
    );
  }

  void _verify(String pin, BuildContext context) async {
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{"code": pin, "email": widget.email},
        ),
        'password/verify');
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, widget.email);
    } else {
      setState(() {
        _isLoading = false;
      });
      _errorSnackbar("${jsonDecode(response.body)}");
    }
  }

  _errorSnackbar(err) {
    final snackBar = SnackBar(
      content: Text("$err"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

//new password

class NewPassword extends StatefulWidget {
  final email;
  const NewPassword({Key? key, this.email}) : super(key: key);
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmationController =
      TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: primary),
      ),
      body: OrientationBuilder(builder: (_, orientation) {
        if (orientation == Orientation.portrait)
          return _buildPortraitLayout(); // if orientation is portrait, show your portrait layout
        else
          return _buildLandscapeLayout(); // else show the landscape one
      }),

      // child: Text("This is where your content goes")
    );
  }

  Padding _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 80,
                          width: 80,
                          child: Image(
                              image: AssetImage("assets/images/logo.png"))),
                      SizedBox(height: 10),
                      Text(
                        "Tings App",
                        style: TextStyle(fontSize: 36),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'New password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordConfirmationController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Password confirmation'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 60.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                            ),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              _submit(context);
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'New password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordConfirmationController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            labelText: 'Password confirmation'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _isLoading
              ? CircularProgressIndicator()
              : SizedBox(
                  height: 56.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      _submit(context);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _submit(context) async {
    if (_passwordController.text != _passwordConfirmationController.text) {
      _errorSnackbar("Passwords not matching!");
      return null;
    }
    Api api = new Api();
    setState(() {
      _isLoading = true;
    });
    var response = await api.post(
        jsonEncode(
          <String, dynamic>{
            'email': widget.email,
            'password': _passwordController.text,
            'password_confirmation': _passwordConfirmationController.text
          },
        ),
        'password/reset');
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      var data = jsonDecode(response.body);
      Navigator.pop(context, data['user']['id']);
    } else {
      setState(() {
        _isLoading = false;
      });
      _errorSnackbar("${jsonDecode(response.body)}");
    }
  }

  _errorSnackbar(err) {
    final snackBar = SnackBar(content: Text("$err"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
