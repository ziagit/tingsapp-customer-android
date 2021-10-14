class Customer {
  int? id;
  String? first_name;
  String? last_name;
  String? phone;
  String? email;
  String? address;
  String? country;
  String? state;
  String? city;
  String? zip;
  int? address_id;

  Customer(this.id, this.first_name, this.last_name, this.phone, this.email,
      this.address,this.country,this.state,this.city,this.zip, this.address_id);
  Customer.fromJson(Map json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    zip = json['zip'];
    address_id = json['address_id'];
  }
  Map toJson() => {
        id: id,
        first_name!: first_name,
        last_name!: last_name,
        phone!: phone,
        email!: email,
        address!: address,
        country!:country,
        state!:state,
        city!:city,
        zip!:zip,
        address_id!: address_id
      };
}
