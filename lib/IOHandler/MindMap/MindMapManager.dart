part of io_handler;

class MindMapManager {
  static const String _mindMapIndexPath = "Index.txt";

  MindMapListModel data;

  List<MindMapModel> recentMindMaps;
  List<MindMapModel> favouriteMindMaps;

  List<MindMapModel> getFiles(MindMapType mindMapType) {
    switch (mindMapType) {
      case MindMapType.All:
        return data.allMindMaps;
      case MindMapType.Recent:
        return recentMindMaps;
      case MindMapType.Favourites:
        return favouriteMindMaps;
      default:
        data.allMindMaps.sort((a, b) => a.title.compareTo(b.title));
        return data.allMindMaps;
    }
  }

  Future<List<MindMapModel>> readFromFile() async {
    var contents = await readFileAsString([_mindMapIndexPath]);
    if (contents == null) {
      data = MindMapListModel();
    } else {
      data = MindMapListModel.fromJson(jsonDecode(contents));
    }
    _updateFileLists();
    return data.allMindMaps;
  }

  void save() => writeFile(jsonEncode(data), [_mindMapIndexPath]);

  void _updateFileLists() {
    var allFiles = [];
    allFiles.addAll(data.allMindMaps);
    allFiles.sort((a, b) => a.lastEditTime.compareTo(b.lastEditTime));

    recentMindMaps = [];
    favouriteMindMaps = [];
    int counter = 0;
    for (int i = allFiles.length - 1; i >= 0; i--) {
      var fileData = allFiles[i];
      if (counter < 10) recentMindMaps.add(fileData);
      if (fileData.isBookMarked) favouriteMindMaps.add(fileData);
      counter++;
    }

    data.allMindMaps.sort((a, b) => a.title.compareTo(b.title));
    favouriteMindMaps.sort((a, b) => a.title.compareTo(b.title));
  }

  void addNewMindMap(MindMapModel model) {
    data.allMindMaps.add(model);
    _updateFileLists();
    save();
  }

  void toggleBookmark(int index) {
    data.allMindMaps[index].toggleBookmark();
    _updateFileLists();
    save();
  }

  void renameMindMap(int index, String newTitle) {
    data.allMindMaps[index].rename(newTitle);
    _updateFileLists();
    save();
  }

  void updateFileLastEdit(int index) {
    data.allMindMaps[index].updateLastEdit();
    _updateFileLists();
    save();
  }

  void deleteMindMapAt(int index) {
    data.allMindMaps.removeAt(index);
    _updateFileLists();
    save();
  }
}

@JsonSerializable()
class MindMapListModel {
  List<MindMapModel> allMindMaps;

  MindMapListModel() {
    allMindMaps = [];
  }

  factory MindMapListModel.fromJson(Map<String, dynamic> json) => _$MindMapListModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapListModelToJson(this);
}
