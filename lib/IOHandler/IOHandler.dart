library io_handler;

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'MindMap/MindMapManager.dart';

part 'MindMap/MindMapModel.dart';

part 'MindMap/MindMapType.dart';

part 'Users/UserManager.dart';

part 'Users/UserModel.dart';

part 'NodeModel.dart';

part 'IOHandler.g.dart';

Future<String> getPersistentPath(List<String> fileDir) async {
  final appDirectory = await getApplicationDocumentsDirectory();
  String filePath = appDirectory.path;
  for (int i = 0; i < fileDir.length; i++) {
    filePath = p.join(filePath, fileDir[i]);
  }
  debugPrint("File path is $filePath");
  return filePath;
}

Future<String> readFileAsString(List<String> fileDir) async {
  final filePath = await getPersistentPath(fileDir);

  if (await File(filePath).exists()) {
    return await File(filePath).readAsString();
  }

  debugPrint("No file found");
  return null;
}

Future<File> writeFile(String encodedJsonData, List<String> fileDir) async {
  final filePath = await getPersistentPath(fileDir);
  final file = File(filePath);
  return file.writeAsString(encodedJsonData);
}
