part of io_handler;

class MindMapFileManager {
  static const String _mindMapIndexPath = "Index.txt";

  String username;

  MindMapFileListModel data;

  List<MindMapFileModel> recentMindMaps;
  List<MindMapFileModel> favouriteMindMaps;

  void setUser(String username) {
    this.username = username;
  }

  Future<List<MindMapFileModel>> readFromFile() async {
    var contents = await readFileAsString([username], _mindMapIndexPath);
    if (contents == null) {
      data = MindMapFileListModel();
    } else {
      data = MindMapFileListModel.fromJson(jsonDecode(contents));
    }
    _updateFileLists();
    return data.allMindMaps;
  }

  List<MindMapFileModel> getFiles(MindMapType mindMapType) {
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

  void save() => writeFile(jsonEncode(data), [username], _mindMapIndexPath);

  List<MindMapFileModel> searchFile(String searchTerm, MindMapType searchedType) {
    if (searchTerm == null) searchTerm = "";
    searchTerm = searchTerm.trim();

    debugPrint("Searching");
    List<MindMapFileModel> tempDomain = [];
    getFiles(searchedType).forEach((element) {
      if (element.title.contains(searchTerm)) tempDomain.add(element);
    });

    // TODO make the list display 'no files found' text or something
    if (tempDomain.isEmpty) {
      debugPrint("Nothing found");
    }

    tempDomain.sort((a, b) => (a.title.toUpperCase()).compareTo(b.title.toUpperCase()));
    return tempDomain;
  }

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

  void addNewMindMap(MindMapFileModel model) {
    data.allMindMaps.add(model);
    _updateFileLists();
    save();
  }

  void toggleBookmark(int index) {
    data.allMindMaps[index].toggleBookmark();
    _updateFileLists();
    save();
  }

  void renameMindMap(String oldName, String newTitle) {
    for (int i = 0; i < data.allMindMaps.length; i++) {
      var element = data.allMindMaps[i];
      if (element.title == oldName) {
        element._rename(newTitle);
        _updateFileLists();
        save();
        return;
      }
    }
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

enum MindMapType {
  All,
  Recent,
  Favourites,
}

@JsonSerializable()
class MindMapFileListModel {
  List<MindMapFileModel> allMindMaps;

  MindMapFileListModel() {
    allMindMaps = [];
  }

  factory MindMapFileListModel.fromJson(Map<String, dynamic> json) => _$MindMapFileListModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapFileListModelToJson(this);
}
