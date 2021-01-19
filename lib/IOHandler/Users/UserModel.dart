part of io_handler;

@JsonSerializable()
class UserModel extends Store<UserModel> {
  String username;
  String password;

  UserModel(this.username, this.password);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  void editUsername(String newUsername) {
    username = newUsername;
  }

  void editPassword(String newPassword) {
    password = newPassword;
  }
}
