part of data_io;

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

  Future<String> get _getFilePath async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final filePath = p.join(appDirectory.path, _fileIndexerPath);
    debugPrint("File path is $filePath");
    return filePath;
  }

  Future<File> get _getJSONFile async {
    final filePath = await _getFilePath;
    if (await File(filePath).exists()) {
      return File(filePath);
    }
    debugPrint("No file found");
    return null;
  }

  Future<MindMapListModel> get readFileIndex async {
    var file = await _getJSONFile;
    if (file == null) {
      data = MindMapListModel();
      file = await writeToFile();
    }
    final contents = await file.readAsString();
    Map fileMap = jsonDecode(contents);
    data = MindMapListModel.fromJson(fileMap);
    _updateFileLists();

    return data;
  }

  Future<File> writeToFile() async {
    final file = File(await _getFilePath);
    return file.writeAsString(jsonEncode(data));
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

  void addNewFile(MindMapModel model) {
    data.allMindMaps.add(model);
    _updateFileLists();
    writeToFile();
  }

  void updateFileLastEdit(int index) {
    data.allMindMaps[index].updateLastEdit();
    _updateFileLists();
    writeToFile();
  }

  void deleteFileAt(int index) {
    data.allMindMaps.removeAt(index);
    _updateFileLists();
    writeToFile();
  }
}
