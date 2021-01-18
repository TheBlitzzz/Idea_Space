part of io_handler;

class UserManager {
  static const String _userListPath = "Users.txt";

  UserListModel data;

  Future<List<UserModel>> readFromFile() async {
    var contents = await readFileAsString([_userListPath]);
    if (contents == null) {
      data = UserListModel();
    } else {
      data = UserListModel.fromJson(jsonDecode(contents));
    }

    return data.allUsers;
  }

  void save() => writeFile(jsonEncode(data), [_userListPath]);

  String getUserPassword(String username) {
    for (int i = 0; i < data.allUsers.length; i++) {
      UserModel user = data.allUsers[i];
      if (data.allUsers[i].username == username) {
        return user.password;
      }
    }
    return null;
  }

  void addNewUser(String username, String password) {
    data.allUsers.add(UserModel(username, password));
    save();
  }

  void deleteUser(int index) {
    data.allUsers.removeAt(index);
    save();
  }
}

@JsonSerializable()
class UserListModel {
  List<UserModel> allUsers;

  UserListModel() {
    allUsers = [];
  }

  factory UserListModel.fromJson(Map<String, dynamic> json) => _$UserListModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserListModelToJson(this);
}
