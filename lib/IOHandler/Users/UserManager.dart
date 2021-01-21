part of io_handler;

class UserManager {
  static const String _userListPath = "Users.txt";

  UserListModel _data;

  //region IO
  Future<List<UserModel>> load() async {
    var contents = await readFileAsString([], _userListPath);
    if (contents == null) {
      reset();
    } else {
      _data = UserListModel.fromJson(jsonDecode(contents));
    }
    return _data.allUsers;
  }

  void save() => writeFile(jsonEncode(_data), [], _userListPath);

  //endregion

  UserModel getUser(String username) {
    for (int i = 0; i < _data.allUsers.length; i++) {
      UserModel user = _data.allUsers[i];
      if (_data.allUsers[i].username == username) {
        return user;
      }
    }
    return null;
  }

  void reset() {
    _data = UserListModel([]);
    save();
  }

  void addNewUser(UserModel newUser) {
    _data.allUsers.add(newUser);
    save();
  }

  void deleteUser(int index) {
    _data.allUsers.removeAt(index);
    save();
  }
}

@JsonSerializable()
class UserListModel {
  List<UserModel> allUsers;

  UserListModel(this.allUsers);

  factory UserListModel.fromJson(Map<String, dynamic> json) => _$UserListModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserListModelToJson(this);
}
