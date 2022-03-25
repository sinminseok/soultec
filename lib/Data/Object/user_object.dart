
class User_token{
  final String? token;
   String? error;

  User_token({this.token,this.error});

  factory User_token.fromJson(Map<String, dynamic> json) {
    return User_token(
      token: json['token'],
    );
  }

}

class User {
   String? username;
   String? nickname;
  final List<dynamic>? authorityDtoSet;



   User({this.username , this.nickname, this.authorityDtoSet});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      nickname: json['nickname'],
      authorityDtoSet: json['authorityDtoSet'],
    );
  }

}




