part of mind_map_data;

class FileIndexer {
  static const String _fileIndexerPath = "Index.txt";

  FileIndexModel data;

  List<MindMapModel> recentFiles;
  List<MindMapModel> favouriteFiles;

  List<MindMapModel> getFiles(FileListType listType) {
    switch (listType) {
      case FileListType.All:
        return data.allFiles;
      case FileListType.Recent:
        return recentFiles;
      case FileListType.Favourites:
        debugPrint(favouriteFiles.length.toString());
        return favouriteFiles;
      default:
        return data.allFiles;
    }
  }

  Future<String> get _getFilePath async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final filePath = p.join(appDirectory.path, _fileIndexerPath);
    debugPrint(filePath);
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

  Future<FileIndexModel> get readFileIndex async {
    var file = await _getJSONFile;
    if (file == null) {
      data = FileIndexModel();
      file = await writeToFile();
    }
    final contents = await file.readAsString();
    Map fileMap = jsonDecode(contents);
    data = FileIndexModel.fromJson(fileMap);
    _updateFileLists();

    return data;
  }

  Future<File> writeToFile() async {
    final file = File(await _getFilePath);
    return file.writeAsString(jsonEncode(data));
  }

  void _updateFileLists() {
    var allFiles = [];
    allFiles.addAll(data.allFiles);
    allFiles.sort((a, b) => a.lastEditTime.compareTo(b.lastEditTime));
    recentFiles = [];
    favouriteFiles = [];
    for (int i = 0; i < allFiles.length; i++) {
      var fileData = allFiles[i];
      if (i < 10) recentFiles.add(fileData);
      if (fileData.isBookMarked) favouriteFiles.add(fileData);
    }
  }

  void addNewFile(MindMapModel model) {
    data.allFiles.add(model);
    _updateFileLists();
    writeToFile();
  }

  void updateFile(int index, MindMapModel model) {
    data.allFiles[index] = model;
    _updateFileLists();
    writeToFile();
  }

  void deleteFileAt(int index) {
    data.allFiles.removeAt(index);
    _updateFileLists();
    writeToFile();
  }
}
