part of io_handler;

@JsonSerializable()
class UserModel {
  String username;
  String password;
  int themeColour;

  UserModel(this.username, this.password, this.themeColour);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  void editPassword(String newPassword) {
    password = newPassword;
  }

  void editThemeColour(Color newColour) {
    themeColour = newColour.value;
  }

  Color get getColour {
    return Color(themeColour);
  }
}
