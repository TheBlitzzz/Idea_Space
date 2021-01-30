// GENERATED CODE - DO NOT MODIFY BY HAND

part of nodes;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeLinkModel _$NodeLinkModelFromJson(Map<String, dynamic> json) {
  return NodeLinkModel(
    json['id'] as int,
    json['startNode'] as int,
    _$enumDecodeNullable(_$eNodeTypeEnumMap, json['startType']),
    json['endNode'] as int,
    _$enumDecodeNullable(_$eNodeTypeEnumMap, json['endType']),
  );
}

Map<String, dynamic> _$NodeLinkModelToJson(NodeLinkModel instance) => <String, dynamic>{
      'id': instance.id,
      'startNode': instance.startNode,
      'startType': _$eNodeTypeEnumMap[instance.startType],
      'endNode': instance.endNode,
      'endType': _$eNodeTypeEnumMap[instance.endType],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries.singleWhere((e) => e.value == source, orElse: () => null)?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$eNodeTypeEnumMap = {
  eNodeType.Page: 'Page',
  eNodeType.Text: 'Text',
  eNodeType.Image: 'Image',
};

PageNodeModel _$PageNodeModelFromJson(Map<String, dynamic> json) {
  return PageNodeModel(
    json['id'] as int,
    (json['width'] as num)?.toDouble(),
    (json['height'] as num)?.toDouble(),
    (json['dx'] as num)?.toDouble(),
    (json['dy'] as num)?.toDouble(),
  )
    ..title = json['title'] as String
    ..colour = json['colour'] as int
    ..nodeTitle = json['nodeTitle'] as String
    ..textBlocks = (json['textBlocks'] as List)
        ?.map((e) => e == null ? null : TextBlockModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PageNodeModelToJson(PageNodeModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'width': instance.width,
      'height': instance.height,
      'dx': instance.dx,
      'dy': instance.dy,
      'colour': instance.colour,
      'nodeTitle': instance.nodeTitle,
      'textBlocks': instance.textBlocks,
    };

TextBlockModel _$TextBlockModelFromJson(Map<String, dynamic> json) {
  return TextBlockModel(
    json['content'] as String,
  )
    ..textSizeIndex = json['textSizeIndex'] as int
    ..isUnderlined = json['isUnderlined'] as bool
    ..isBold = json['isBold'] as bool
    ..isItalic = json['isItalic'] as bool;
}

Map<String, dynamic> _$TextBlockModelToJson(TextBlockModel instance) => <String, dynamic>{
      'content': instance.content,
      'textSizeIndex': instance.textSizeIndex,
      'isUnderlined': instance.isUnderlined,
      'isBold': instance.isBold,
      'isItalic': instance.isItalic,
    };

TextNodeModel _$TextNodeModelFromJson(Map<String, dynamic> json) {
  return TextNodeModel(
    json['id'] as int,
    (json['width'] as num)?.toDouble(),
    (json['height'] as num)?.toDouble(),
    (json['dx'] as num)?.toDouble(),
    (json['dy'] as num)?.toDouble(),
  )
    ..title = json['title'] as String
    ..colour = json['colour'] as int;
}

Map<String, dynamic> _$TextNodeModelToJson(TextNodeModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'width': instance.width,
      'height': instance.height,
      'dx': instance.dx,
      'dy': instance.dy,
      'colour': instance.colour,
    };

ImageNodeModel _$ImageNodeModelFromJson(Map<String, dynamic> json) {
  return ImageNodeModel(
    json['id'] as int,
    (json['width'] as num)?.toDouble(),
    (json['height'] as num)?.toDouble(),
    (json['dx'] as num)?.toDouble(),
    (json['dy'] as num)?.toDouble(),
    json['imageInBase64'] as String,
  )
    ..title = json['title'] as String
    ..colour = json['colour'] as int;
}

Map<String, dynamic> _$ImageNodeModelToJson(ImageNodeModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'width': instance.width,
      'height': instance.height,
      'dx': instance.dx,
      'dy': instance.dy,
      'colour': instance.colour,
      'imageInBase64': instance.imageInBase64,
    };
