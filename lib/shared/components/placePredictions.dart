class PlacePredictions {
  String? description;
  String? secondary_text;
  String? main_text;
  String? place_id;
  PlacePredictions(
      {this.description, this.secondary_text, this.main_text, this.place_id});

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    place_id = json['place_id'];
    main_text = json['structured_formatting']['main_text'];
    secondary_text = json['structured_formatting']['secondary_text'];
  }
}
