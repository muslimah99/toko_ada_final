class User {
  String? id;
  String? level;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? regdate;

  User({
    required this.id,
    required this.level,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.regdate,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    regdate = json['regdate'];
  }
}
