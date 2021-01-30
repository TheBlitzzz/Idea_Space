// GENERATED CODE - DO NOT MODIFY BY HAND

part of mind_map;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MindMapModel _$MindMapModelFromJson(Map<String, dynamic> json) {
  return MindMapModel(
    json['fileData'] == null ? null : MindMapFileModel.fromJson(json['fileData'] as Map<String, dynamic>),
  )
    ..nodeIndexCount = json['nodeIndexCount'] as int
    ..linkIndexCount = json['linkIndexCount'] as int
    ..pageNodes = (json['pageNodes'] as List)
        ?.map((e) => e == null ? null : PageNodeModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..textNodes = (json['textNodes'] as List)
        ?.map((e) => e == null ? null : TextNodeModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..imageNodes = (json['imageNodes'] as List)
        ?.map((e) => e == null ? null : ImageNodeModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..links = (json['links'] as List)
        ?.map((e) => e == null ? null : NodeLinkModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$MindMapModelToJson(MindMapModel instance) => <String, dynamic>{
      'fileData': instance.fileData,
      'nodeIndexCount': instance.nodeIndexCount,
      'linkIndexCount': instance.linkIndexCount,
      'pageNodes': instance.pageNodes,
      'textNodes': instance.textNodes,
      'imageNodes': instance.imageNodes,
      'links': instance.links,
    };
