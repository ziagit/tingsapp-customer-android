class MovingDateModel {
  String? date;
  String? time;

  MovingDateModel();

  MovingDateModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }
  Map<String, dynamic> toJson() => {
        'date': date,
        'time': time,
      };
}
