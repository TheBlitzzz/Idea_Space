part of io_handler;

class MindMapFileManager {
  static const String _mindMapIndexPath = "Index.txt";

  String username;

  MindMapFileListModel _data;

  List<MindMapModel> allFiles;
  List<MindMapFileModel> recentMindMaps;
  List<MindMapFileModel> favouriteMindMaps;

  void setUser(String username) {
    this.username = username;
  }

  Future<List<MindMapFileModel>> load() async {
    var contents = await readFileAsString([username], _mindMapIndexPath);
    if (contents == null) {
      deleteAll();
    } else {
      _data = MindMapFileListModel.fromJson(jsonDecode(contents));
    }
    _updateFileLists();
    return _data.allMindMaps;
  }

  void save() => writeFile(jsonEncode(_data), [username], _mindMapIndexPath);

  List<MindMapFileModel> getFiles(MindMapType mindMapType) {
    switch (mindMapType) {
      case MindMapType.All:
        return _data.allMindMaps;
      case MindMapType.Recent:
        return recentMindMaps;
      case MindMapType.Favourites:
        return favouriteMindMaps;
      default:
        _data.allMindMaps.sort((a, b) => a.title.compareTo(b.title));
        return _data.allMindMaps;
    }
  }

  Future<MindMapModel> getMindMap(String mindMapTitle) async {
    var contents = await readFileAsString([username], mindMapTitle + ".txt");
    return MindMapModel.fromJson(jsonDecode(contents));
  }

  void renameUser(String newUsername) {
    renameDir([username], [newUsername]);
    username = newUsername;
    _data.allMindMaps.forEach((mindMap) {
      mindMap.parentUser = username;
    });
    save();
  }

  void deleteAll() {
    if (_data?.allMindMaps != null) {
      for (var mindMap in _data.allMindMaps) {
        deleteMindMap(mindMap.title);
      }
    }

    reset();
  }

  void reset() {
    _data = MindMapFileListModel([]);
    save();
  }

  List<MindMapFileModel> searchFile(String searchTerm, MindMapType searchedType) {
    if (searchTerm == null) searchTerm = "";
    searchTerm = searchTerm.trim();

    debugPrint("Searching");
    List<MindMapFileModel> tempDomain = [];

    getFiles(searchedType).forEach((element) {
      if (element.title.contains(searchTerm)) tempDomain.add(element);
    });

    if (searchedType != MindMapType.Recent)
      tempDomain.sort((a, b) => (a.title.toUpperCase()).compareTo(b.title.toUpperCase()));
    return tempDomain;
  }

  void _updateFileLists() {
    List<MindMapFileModel> allFiles = [];
    allFiles.addAll(_data.allMindMaps);
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

    _data.allMindMaps.sort((a, b) => a.title.compareTo(b.title));
    favouriteMindMaps.sort((a, b) => a.title.compareTo(b.title));
  }

  void addNewMindMap(MindMapFileModel model) {
    _data.allMindMaps.add(model);
    var newMindMapModel = MindMapModel(model);
    writeFile(jsonEncode(newMindMapModel), [model.parentUser], model.fileName);
    _updateFileLists();
    save();
  }

  void toggleBookmark(int index) {
    _data.allMindMaps[index].toggleBookmark();
    _updateFileLists();
    save();
  }

  void renameMindMap(MindMapModel mindMap, String newTitle) async {
    for (int i = 0; i < _data.allMindMaps.length; i++) {
      var element = _data.allMindMaps[i];
      if (element.title == mindMap.fileData.title) {
        // Renames the file data
        element._rename(newTitle);
        _updateFileLists();

        // Renames the Mind Map Model
        var oldName = mindMap.fileData.title;
        mindMap.fileData = element;
        // Renaming the actual file
        renameFile([element.parentUser], oldName, [element.parentUser], element.fileName);
        mindMap.save();
        save();
        return;
      }
    }
  }

  void updateFileLastEdit(MindMapFileModel fileData) {
    fileData.updateLastEdit();
    _updateFileLists();
    save();
  }

  void deleteMindMap(String title) {
    int index;
    for (int i = 0; i < _data.allMindMaps.length; i++) {
      var mindMap = _data.allMindMaps[i];
      if (mindMap.title == title) {
        index = i;
        deleteFile([username], mindMap.fileName);
      }
    }

    if (index != null) {
      _data.allMindMaps.removeAt(index);
      _updateFileLists();
      save();
    } else {
      debugPrint("No such file : $title");
    }
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

  MindMapFileListModel(this.allMindMaps);

  //region JSON
  factory MindMapFileListModel.fromJson(Map<String, dynamic> json) => _$MindMapFileListModelFromJson(json);
  Map<String, dynamic> toJson() => _$MindMapFileListModelToJson(this);
//endregion
}
