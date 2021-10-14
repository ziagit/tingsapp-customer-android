class FromAddressModel {
  String? country;
  String? state;
  String? city;
  String? zip;
  String? street;
  String? street_number;
  String? formatted_address;
  double? latitude;
  double? longitude;

  FromAddressModel();

  FromAddressModel.fromJson(Map<String, dynamic> json) {
    if (json['types'].indexOf("street_number") > -1) {
      street_number = json['long_name'];
    }
    if (json['types'].indexOf("route") > -1) {
      street = json['long_name'];
    }
    if (json['types'].indexOf("locality") > -1) {
      city = json['long_name'];
    }
    if (json['types'].indexOf("administrative_area_level_1") > -1) {
      state = json['short_name'];
    }
    if (json['types'].indexOf("postal_code") > -1) {
      zip = json['long_name'];
    }
    if (json['types'].indexOf("country") > -1) {
      country = json['long_name'];
    }
    formatted_address = json['formatted_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
  Map<String, dynamic> toJson() => {
        'country': country,
        'state': state,
        'city': city,
        'zip': zip,
        'street': street,
        'street_number': street_number,
        'formatted_address': formatted_address,
        'latitude': latitude,
        'longitude': longitude,
      };
}
