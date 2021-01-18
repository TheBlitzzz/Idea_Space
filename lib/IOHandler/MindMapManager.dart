part of io_handler;

class MindMapManager {
  static const String _fileIndexerPath = "Index.txt";

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

  Future<MindMapListModel> get readFileIndex async {
    var contents = await readFileAsString([_fileIndexerPath]);
    if (contents == null) {
      data = MindMapListModel();
      return data;
    }

    data = MindMapListModel.fromJson(jsonDecode(contents));
    _updateFileLists();

    return data;
  }

  void save() => writeFile(jsonEncode(data), [_fileIndexerPath]);

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

  void addNewFile(MindMapModel model) {
    data.allMindMaps.add(model);
    _updateFileLists();
    save();
  }

  void updateFileLastEdit(int index) {
    data.allMindMaps[index].updateLastEdit();
    _updateFileLists();
    save();
  }

  void deleteFileAt(int index) {
    data.allMindMaps.removeAt(index);
    _updateFileLists();
    save();
  }
}
