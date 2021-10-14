class Mover {
  int? id;
  String? first_name;
  String? last_name;
  int? year_established;
  int? employees;
  int? vehicles;
  double? hourly_rate;
  String? phone;
  String? company;
  String? detail;
  double? votes;
  String? website;
  String? logo;
  double? price;

  double? travel;
  double? moving;
  double? supplies_cost;
  double? service_fee;
  double? disposal_fee;
  double? tax;

  Mover(
      this.id,
      this.first_name,
      this.last_name,
      this.year_established,
      this.employees,
      this.vehicles,
      this.hourly_rate,
      this.phone,
      this.price,
      this.company,
      this.detail,
      this.votes,
      this.website,
      this.logo,
      this.travel,
      this.moving,
      this.supplies_cost,
      this.service_fee,
      this.disposal_fee,
      this.tax);

  Mover.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    year_established = json['year_established'];
    employees = json['employees'];
    vehicles = json['vehicles'];
    hourly_rate = json['hourly_rate'];
    phone = json['phone'];
    price = json['price'].toDouble();
    company = json['company'];
    detail = json['detail'];
    votes = json['votes'].toDouble();
    website = json['website'];
    logo = json['logo'];
    travel = json['travel'];
    moving = json['moving'];
    supplies_cost = json['supplies_cost'];
    disposal_fee = json['disposal_fee'];
    service_fee = json['service_fee'];
    tax = json['tax'];
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'year_established': year_established,
        'employees': employees,
        'vehicles': vehicles,
        'hourly_rate': hourly_rate,
        'phone': phone,
        'price': price,
        'company': company,
        'detail': detail,
        'votes': votes,
        'website': website,
        'logo': logo,
        'travel': travel,
        'moving': moving,
        'supplies_cost': supplies_cost,
        'service_fee': service_fee,
        'disposal_fee': disposal_fee,
        'tax': tax,
      };
}
