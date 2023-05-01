class User {
  String? userFirstName;
  String? userLastName;
  String? userEmail;
  String? userPassword;

  User(
      {this.userFirstName,
      this.userLastName,
      required this.userEmail,
      required this.userPassword});

  User.fromJson(Map<String, dynamic> json) {
    userFirstName = json['userFirstName'];
    userLastName = json['userLastName'];
    userEmail = json['userEmail'];
    userPassword = json['userPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userFirstName'] = this.userFirstName;
    data['userLastName'] = this.userLastName;
    data['userEmail'] = this.userEmail;
    data['userPassword'] = this.userPassword;
    return data;
  }
}