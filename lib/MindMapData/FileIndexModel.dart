part of mind_map_data;

@JsonSerializable()
class FileIndexModel {
  List<MindMapModel> allInLocalMachine;
  List<MindMapModel> recentFiles;
  List<MindMapModel> favouriteFiles;
  List<MindMapModel> sharedFiles;

  FileIndexModel() {
    allInLocalMachine = [];
    recentFiles = [];
    favouriteFiles = [];
    sharedFiles = [];
  }

  factory FileIndexModel.fromJson(Map<String, dynamic> json) => _$FileIndexModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileIndexModelToJson(this);
}
