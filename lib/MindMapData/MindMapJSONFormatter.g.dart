// GENERATED CODE - DO NOT MODIFY BY HAND

part of mind_map_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileIndexModel _$FileIndexModelFromJson(Map<String, dynamic> json) {
  return FileIndexModel()
    ..allInLocalMachine = (json['allInLocalMachine'] as List)
        ?.map((e) => e == null ? null : MindMapModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..recentFiles = (json['recentFiles'] as List)
        ?.map((e) => e == null ? null : MindMapModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..favouriteFiles = (json['favouriteFiles'] as List)
        ?.map((e) => e == null ? null : MindMapModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..sharedFiles = (json['sharedFiles'] as List)
        ?.map((e) => e == null ? null : MindMapModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$FileIndexModelToJson(FileIndexModel instance) => <String, dynamic>{
      'allInLocalMachine': instance.allInLocalMachine,
      'recentFiles': instance.recentFiles,
      'favouriteFiles': instance.favouriteFiles,
      'sharedFiles': instance.sharedFiles,
    };

MindMapModel _$MindMapModelFromJson(Map<String, dynamic> json) {
  return MindMapModel(
    json['filePath'] as String,
    json['title'] as String,
    json['lastEditTime'] == null ? null : DateTime.parse(json['lastEditTime'] as String),
  );
}

Map<String, dynamic> _$MindMapModelToJson(MindMapModel instance) => <String, dynamic>{
      'filePath': instance.filePath,
      'title': instance.title,
      'lastEditTime': instance.lastEditTime?.toIso8601String(),
    };

NodeModel _$NodeModelFromJson(Map<String, dynamic> json) {
  return NodeModel(
    (json['posX'] as num)?.toDouble(),
    (json['posY'] as num)?.toDouble(),
    (json['sizeX'] as num)?.toDouble(),
    (json['sizeY'] as num)?.toDouble(),
    json['title'] as String,
  );
}

Map<String, dynamic> _$NodeModelToJson(NodeModel instance) => <String, dynamic>{
      'posX': instance.posX,
      'posY': instance.posY,
      'sizeX': instance.sizeX,
      'sizeY': instance.sizeY,
      'title': instance.title,
    };
