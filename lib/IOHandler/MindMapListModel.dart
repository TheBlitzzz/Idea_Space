part of io_handler;

@JsonSerializable()
class MindMapListModel {
  List<MindMapModel> allMindMaps;

  MindMapListModel() {
    allMindMaps = [];
  }

  factory MindMapListModel.fromJson(Map<String, dynamic> json) => _$MindMapListModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapListModelToJson(this);
}
