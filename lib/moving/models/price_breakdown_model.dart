class PriceBreakdownModel {
  double? travel_cost;
  double? moving_cost;
  double? supplies_cost;
  double? service_fee;
  double? disposal_fee;
  double? tax;

  PriceBreakdownModel(this.travel_cost, this.moving_cost, this.supplies_cost,
      this.service_fee, this.disposal_fee, this.tax);

  PriceBreakdownModel.fromJson(Map<String, dynamic> json) {
    travel_cost = json['travel_cost'];
    moving_cost = json['moving_cost'];
    supplies_cost = json['supplies_cost'];
    service_fee = json['service_fee'];
    disposal_fee = json['disposal_fee'];
    tax = json['tax'];
  }
  Map<String, dynamic> toJson() => {
        'travel_cost': travel_cost,
        'moving_cost': moving_cost,
        'supplies_cost': supplies_cost,
        'service_fee': service_fee,
        'disposal_fee': disposal_fee,
        'tax': tax,
      };
}
