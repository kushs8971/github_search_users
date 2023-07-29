class User {
  String? login;
  String? avatarUrl;

  User({this.login, this.avatarUrl});

  User.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['login'] = login;
    data['avatar_url'] = avatarUrl;
    return data;
  }
}