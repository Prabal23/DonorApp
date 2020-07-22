class User {
  final String name;
  final String email;
  final String password;
  final String phone;

  User(this.name, this.email, this.password, this.phone);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'],
        phone = json['phone'];

  Map<String, dynamic> toJson() =>
    {
      'name': name,
      'email': email,
    };
}