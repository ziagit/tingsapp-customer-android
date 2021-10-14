class User {
  int? id;
  String? avatar;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? confirm_password;

  User(this.id,this.avatar, this.name, this.email,this.phone, this.password, this.confirm_password);

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    confirm_password = json['confirm_password'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'name': name,
        'email': email,
        'phone':phone,
        'password': password,
        'confirm_password': confirm_password
      };
}
