// GENERATED CODE - DO NOT MODIFY BY HAND

part of io_handler;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MindMapFileListModel _$MindMapFileListModelFromJson(Map<String, dynamic> json) {
  return MindMapFileListModel(
    (json['allMindMaps'] as List)
        ?.map((e) => e == null ? null : MindMapFileModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MindMapFileListModelToJson(MindMapFileListModel instance) => <String, dynamic>{
      'allMindMaps': instance.allMindMaps,
    };

MindMapFileModel _$MindMapFileModelFromJson(Map<String, dynamic> json) {
  return MindMapFileModel(
    json['title'] as String,
    json['parentUser'] as String,
    json['lastEditTime'] == null ? null : DateTime.parse(json['lastEditTime'] as String),
  )..isBookMarked = json['isBookMarked'] as bool;
}

Map<String, dynamic> _$MindMapFileModelToJson(MindMapFileModel instance) => <String, dynamic>{
      'title': instance.title,
      'parentUser': instance.parentUser,
      'lastEditTime': instance.lastEditTime?.toIso8601String(),
      'isBookMarked': instance.isBookMarked,
    };

UserListModel _$UserListModelFromJson(Map<String, dynamic> json) {
  return UserListModel(
    (json['allUsers'] as List)?.map((e) => e == null ? null : UserModel.fromJson(e as Map<String, dynamic>))?.toList(),
  );
}

Map<String, dynamic> _$UserListModelToJson(UserListModel instance) => <String, dynamic>{
      'allUsers': instance.allUsers,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['username'] as String,
    json['password'] as String,
    json['themeColour'] as int,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'themeColour': instance.themeColour,
    };
