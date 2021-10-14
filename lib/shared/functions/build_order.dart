import 'package:customer/shared/services/store.dart';

Store _store = Store();
Future buildOrder() async {
  var order = {};
  order['from'] = await _store.read('from');
  order['to'] = await _store.read('to');
  order['moving_size'] = await _store.read('moving-size');
  order['vehicle'] = await _store.read('vehicle');
  order['number_of_movers'] = await _store.read('mover-number');
  order['floors'] = await _store.read('floors');
  order['moving_date'] = await _store.read('moving-date');
  order['instructions'] = await _store.read('instructions');
  order['contacts'] = await _store.read('contacts');
  order['moving_type'] = await _store.read('type');
  order['items'] = await _store.read('items');
  order['distance'] = await _store.read('distance');
  order['duration'] = await _store.read('duration');
  order['carrier'] = await _store.read('carrier');
  order['editable_id'] =await _store.read('editable_id');
  order['old_carrier'] =await _store.read('old_carrier');
  var supplies = await _store.read('supplies');
  order['supplies'] = [];
  for (int i = 0; i < supplies.length; i++) {
    var obj = {"name": "", "code": "", "number": ""};
    if (supplies[i]['number'] is String) {
      obj['name'] = supplies[i]['name'];
      obj['code'] = supplies[i]['code'];
      obj['number'] = supplies[i]['number'];
      order['supplies'].add(obj);
    }
  }
  return order;
}
