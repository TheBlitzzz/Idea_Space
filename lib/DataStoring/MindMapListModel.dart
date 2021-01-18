part of data_io;

@JsonSerializable()
class MindMapListModel {
  List<MindMapModel> allMindMaps;

  MindMapListModel() {
    allMindMaps = [];
  }

  factory MindMapListModel.fromJson(Map<String, dynamic> json) => _$FileIndexModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileIndexModelToJson(this);
}
