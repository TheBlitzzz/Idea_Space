// GENERATED CODE - DO NOT MODIFY BY HAND

part of io_handler;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MindMapListModel _$MindMapListModelFromJson(Map<String, dynamic> json) {
  return MindMapListModel()
    ..allMindMaps = (json['allFiles'] as List)
        ?.map((e) => e == null ? null : MindMapModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$MindMapListModelToJson(MindMapListModel instance) => <String, dynamic>{
      'allFiles': instance.allMindMaps,
    };

MindMapModel _$MindMapModelFromJson(Map<String, dynamic> json) {
  return MindMapModel(
    json['filePath'] as String,
    json['title'] as String,
    json['lastEditTime'] == null ? null : DateTime.parse(json['lastEditTime'] as String),
    isBookMarked: json['isBookMarked'] as bool,
  );
}

Map<String, dynamic> _$MindMapModelToJson(MindMapModel instance) => <String, dynamic>{
      'filePath': instance.filePath,
      'title': instance.title,
      'lastEditTime': instance.lastEditTime?.toIso8601String(),
      'isBookMarked': instance.isBookMarked,
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
