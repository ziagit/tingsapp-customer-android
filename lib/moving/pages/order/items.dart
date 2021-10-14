import 'dart:convert';

import 'package:customer/moving/pages/order/floors.dart';
import 'package:customer/moving/pages/order/moving_types.dart';
import 'package:customer/shared/components/card_decoration.dart';
import 'package:customer/shared/components/custom_appbar.dart';
import 'package:customer/shared/components/custom_title.dart';
import 'package:customer/shared/components/error_message.dart';
import 'package:customer/shared/components/slide_bottom_route.dart';
import 'package:customer/shared/components/slide_left_route.dart';
import 'package:customer/shared/components/slide_right_route.dart';
import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/colors.dart';
import 'package:flutter/material.dart';
import 'package:customer/moving/moving_menu.dart';
import 'package:customer/shared/components/progress.dart';
import 'package:customer/shared/services/store.dart';

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  Store _store = Store();
  bool rememberMe = false;
  List? _list = [];
  String? _errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MovingMenu(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 0, left: 8, right: 8),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                CustomAppbar(),
                Container(child: Progress(progress: 40.0)),
                CustomTitle(title: "Please add your items"),
                Visibility(
                    visible: _errorMsg != null,
                    child: ErrorMessage(msg: "$_errorMsg")),
                Container(
                  padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primary!),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                      child: Text('+ Add item'),
                      onPressed: () => _addItem(context),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: _list!.length == 0
                      ? ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(16),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text("Item not selected"))),
                          ],
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _list!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: cardDecoration(context),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 9,
                                    child: Row(
                                      children: [
                                        Text("${_list![index]['name']}:"),
                                        SizedBox(width: 10),
                                        Text("${_list![index]['number']}"),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () =>
                                                {_delete(context, index)},
                                          ),
                                        ),
                                        Flexible(
                                          child: IconButton(
                                            icon: Icon(Icons.edit),
                                            color: Colors.green,
                                            onPressed: () => {
                                              _edit(
                                                  context, _list![index], index)
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: 1,
              onPressed: () => _back(context),
              child: Icon(Icons.arrow_back, color: primary),
            ),
            FloatingActionButton(
              backgroundColor: primary,
              heroTag: 2,
              onPressed: () => _next(context),
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    var store = await _store.read('items');
    if (store.length > 0) {
      setState(() {
        _list = store;
      });
    }
  }

  _addItem(context) {
    Navigator.of(context)
        .push(
          SlideBottomRoute(
            page: AddItem(),
          ),
        )
        .then(
          (value) => {
            if (value != null)
              {
                _push(value),
              }
          },
        );
  }

  _push(value) {
    bool flag = false;
    for (int i = 0; i < _list!.length; i++) {
      if (_list![i]['code'] == value['code']) {
        flag = true;
      }
    }
    if (!flag) {
      setState(() {
        _list!.add(value);
      });
      flag = false;
    }
  }

  _update(value) {
    int i = value['index'];
    var temp = {
      'name': value['name'],
      'code': value['code'],
      'number': value['number']
    };
    setState(() {
      _list![i] = temp;
    });
  }

  _edit(context, item, index) {
    Navigator.of(context)
        .push(
          SlideBottomRoute(
            page: EditItem(item: item, index: index),
          ),
        )
        .then(
          (value) => {
            if (value != null) {_update(value)}
          },
        );
  }

  _delete(context, index) {
    setState(() {
      _list!.removeAt(index);
    });
  }

  _back(context) {
    Navigator.pushReplacement(context, SlideLeftRoute(page: MovingTypes()));
  }

  _next(context) async {
    if (_list!.length > 0) {
      await _store.save('items', _list);
      Navigator.pushReplacement(context, SlideRightRoute(page: Floors()));
    } else {
      setState(() {
        _errorMsg = "Please fill out the required fields";
      });
    }
  }
}

//Add item widget
class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController _numberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  List _list = [];
  List _searchResult = [];
  var _selected;
  bool _isLoading = true;
  String? _errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: primary,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Column(
            children: [
              Visibility(
                  visible: _errorMsg != null,
                  child: ErrorMessage(msg: "$_errorMsg")),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Search item',
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        isDense: true,
                      ),
                      onChanged: onSearchTextChanged,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _numberController,
                      decoration: InputDecoration(
                        labelText: 'Qty',
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        isDense: true,
                      ),
                      validator: (value) {
                        if (value != null) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              _isLoading
                  ? SizedBox(
                      height: 100,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: primary,
                      )))
                  : Expanded(
                      child: _searchResult.length != 0 ||
                              _nameController.text.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResult.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = _searchResult[index];
                                return _buildItem(item);
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _list.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = _list[index];
                                return _buildItem(item);
                              },
                            ),
                    )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          _add(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  //get items from api
  _init() async {
    Api api = new Api();
    var response = await api.get('items');
    if (response.statusCode == 200) {
      setState(() {
        _list = jsonDecode(response.body);
        _isLoading = false;
      });
    }
  }

  Widget _buildItem(item) => ListTile(
        title: Text(item['name']),
        onTap: () => {_select(item)},
      );

//search item
  onSearchTextChanged(String query) async {
    _searchResult.clear();
    if (query.isEmpty) {
      setState(() {});
      return;
    }
    final queryLowercase = query.toLowerCase();
    _list.forEach((item) {
      final nameLowercase = item['name'].toLowerCase();
      if (nameLowercase.contains(queryLowercase)) _searchResult.add(item);
    });
    setState(() {});
  }

//select item
  _select(item) {
    setState(() {
      _nameController.text = item['name'];
      _searchResult.length = 0;
      var temp = {'name': item['name'], 'code': item['code']};
      _selected = temp;
    });
  }

  //add item
  _add(context) {
    if (_nameController.text.length != 0 &&
        _numberController.text.length != 0) {
      _selected['number'] = _numberController.text;
      Navigator.pop(context, _selected);
    } else {
      setState(() {
        _errorMsg = "Please fill out the required fields";
      });
    }
  }
}

//Edit item widget
class EditItem extends StatefulWidget {
  final item;
  final index;
  const EditItem({Key? key, this.item, this.index}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  TextEditingController _numberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  List _list = [];
  List _searchResult = [];
  var _selected;
  bool _isLoading = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: primary,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Visibility(
                visible: _errorMsg != null,
                child: ErrorMessage(msg: "$_errorMsg")),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Search item',
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                        ),
                      ),
                      isDense: true,
                    ),
                    onChanged: onSearchTextChanged,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _numberController,
                    decoration: InputDecoration(
                      labelText: 'Qty',
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value != null) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            _isLoading
                ? SizedBox(
                    height: 100,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: primary,
                    )))
                : Expanded(
                    child: _searchResult.length != 0 ||
                            _nameController.text.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchResult.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _searchResult[index];
                              return _buildItem(item);
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _list.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = _list[index];
                              return _buildItem(item);
                            },
                          ),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          _add(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  //get items from api
  _init() async {
    Api api = new Api();
    setState(() {
      _nameController.text = widget.item['name'];
      _numberController.text = widget.item['number'];
    });
    var response = await api.get('items');
    if (response.statusCode == 200) {
      setState(() {
        _list = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      final snackBar = SnackBar(
          content: Text(
        jsonDecode(response.body),
        style: TextStyle(color: Colors.red),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _buildItem(item) => ListTile(
        title: Text(item['name']),
        onTap: () => {_select(item)},
      );

//search item
  onSearchTextChanged(String query) async {
    _searchResult.clear();
    if (query.isEmpty) {
      setState(() {});
      return;
    }
    final queryLowercase = query.toLowerCase();
    _list.forEach((item) {
      final nameLowercase = item['name'].toLowerCase();
      if (nameLowercase.contains(queryLowercase)) _searchResult.add(item);
    });
    setState(() {});
  }

//select item
  _select(item) {
    setState(() {
      _nameController.text = item['name'];
      _searchResult.length = 0;
      var temp = {'name': item['name'], 'code': item['code']};
      _selected = temp;
    });
  }

  //add item
  _add(context) {
    if (_nameController.text.length != 0 &&
        _numberController.text.length != 0) {
      if (_selected == null) {
        var temp = {'name': _nameController.text, 'code': widget.item['code']};
        _selected = temp;
      }
      _selected['number'] = _numberController.text;
      _selected['index'] = widget.index;
      Navigator.pop(context, _selected);
    } else {
      setState(() {
        _errorMsg = "Please fill out the required fields";
      });
    }
  }
}
