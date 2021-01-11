part of mind_map_data;

class FileIndexer {
  static const String _fileIndexerPath = "Index.txt";

  FileIndexModel data;

  FileIndexer() {
    data = FileIndexModel();
  }

  Future<String> get _getAppPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getJSONFile async {
    final appPath = await _getAppPath;
    final filePath = p.join(appPath, _fileIndexerPath);
    if (await File(filePath).exists()) {
      return File(p.join(appPath, _fileIndexerPath));
    }

    // Creates a new file if there isn't any.
    data = FileIndexModel();
    return await writeFileIndexes(data);
  }

  Future<FileIndexModel> get readFileIndexes async {
    // if (data == null) {
    final file = await _getJSONFile;
    // TODO Potentially convert this into Streams? Then can load chunk by chunk
    final contents = await file.readAsString();
    Map fileMap = jsonDecode(contents);
    data = FileIndexModel.fromJson(fileMap);
    // }
    return data;
  }

  Future<File> writeFileIndexes(FileIndexModel model) async {
    final file = await _getJSONFile;
    return file.writeAsString(jsonEncode(model));
  }
}
