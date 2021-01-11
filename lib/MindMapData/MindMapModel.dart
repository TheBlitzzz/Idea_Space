part of mind_map_data;

@JsonSerializable()
class MindMapModel {
  String filePath;
  String title;
  DateTime lastEditTime;

  MindMapModel(this.filePath, this.title, this.lastEditTime);

  factory MindMapModel.fromJson(Map<String, dynamic> json) => _$MindMapModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapModelToJson(this);
}
