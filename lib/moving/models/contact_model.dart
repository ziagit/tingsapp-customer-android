class ContactModel {
  String? name;
  String? phone;
  String? email;
  String? instructions;

  ContactModel();
  ContactModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    instructions = json['instructions'];
  }
  Map<String, dynamic> toJson() =>
      {name!: name, phone!: phone, email!: email, instructions!: instructions};
}
