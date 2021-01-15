part of mind_map_data;

@JsonSerializable()
class FileIndexModel {
  List<MindMapModel> allFiles;

  FileIndexModel() {
    allFiles = [];
  }

  factory FileIndexModel.fromJson(Map<String, dynamic> json) => _$FileIndexModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileIndexModelToJson(this);
}
