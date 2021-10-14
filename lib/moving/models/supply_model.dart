class SupplyModel {
  String? name;
  int? number;
  String? code;

  SupplyModel();
  SupplyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];
    code = json['code'];
  }
  Map<String, dynamic> toJson() =>
      {'name': name, 'number': number, 'code': code};
}
