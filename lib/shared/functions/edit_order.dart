import 'dart:convert';

import 'package:customer/shared/services/api.dart';
import 'package:customer/shared/services/store.dart';

Store _store = Store();
Future editOrder(order) async {
  _store.save('editable_id', order['id']);
  _store.save('old_carrier', order['job_with_carrier']['carrier_detail']['id']);
  _store.save('from', order['addresses'][0]);
  _store.save('to', order['addresses'][1]);
  _store.save('type', order['movingtype']);
  _store.save('moving-size', await _buildSize(order));
  _store.save('vehicle', order['vehicle']);
  _store.save('instructions', order['instructions']);
  _store.save('mover-number', order['movernumber']);
  _store.save('floors', await _buildFloors(order));
  _store.save('moving-date', await _buildDate(order));
  _store.save('supplies', await _buildSupplies(order));
  _store.save('items', await _buildItems(order));

  return order;
}

_buildFloors(order) {
  return {'pickup': order['floor_from'], 'destination': order['floor_to']};
}

_buildDate(order) {
  return {'date': order['pickup_date'], 'time': order['appointment_time']};
}

_buildSize(order) {
  if (order['movingtype']['code'] == 'office') {
    return order['officesize'];
  }
  return order['movingsize'];
}

Future<List> _buildSupplies(order) async {
  Api api = new Api();
  var sups = await order['supplies'];
  var response = await api.get('moving-supplies');
  var supplies = jsonDecode(response.body);
  List newSupplies = [];
  var obj = {};
  if (response.statusCode == 200) {
    for (int i = 0; i < supplies.length; i++) {
      bool flag = false;
      for (int j = 0; j < sups.length; j++) {
        if (supplies[i]['code'] == sups[j]['code']) {
          obj = {
            'id': sups[j]['id'],
            'name': sups[j]['name'],
            'code': sups[j]['code'],
            'number': sups[j]['pivot']['number'].toString(),
            'price': sups[j]['price']
          };
          newSupplies.add(obj);
          flag = true;
        }
      }
      if (flag == false) {
        obj = {
          'id': supplies[i]['id'],
          'name': supplies[i]['name'],
          'code': supplies[i]['code'],
          'number': 0,
          'price': supplies[i]['price'],
        };
        newSupplies.add(obj);
      }
    }
  }
  return newSupplies;
}

Future<List> _buildItems(order) async {
  List items = await order['items'];
  List newItems = [];
  for (int i = 0; i < items.length; i++) {
    var obj = {
      'name': items[i]['name'],
      'code': items[i]['code'],
      'number': items[i]['pivot']['number']
    };
    newItems.add(obj);
  }
  return newItems;
}
