library io_handler;

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:idea_space/MindMapping/MindMap.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'MindMap/MindMapFileManager.dart';
part 'MindMap/MindMapFileModel.dart';

part 'Users/UserManager.dart';
part 'Users/UserModel.dart';

part 'NodeModel.dart';

part 'IOHandler.g.dart';

Future<Directory> _getPersistentPath(List<String> fileDir) async {
  final appDirectory = await getApplicationDocumentsDirectory();
  String filePath = appDirectory.path;
  for (int i = 0; i < fileDir.length; i++) {
    filePath = p.join(filePath, fileDir[i]);
  }

  Directory dir = Directory(filePath);
  await dir.create(recursive: true);
  return dir;
}

Future<String> readFileAsString(List<String> fileDir, String fileName) async {
  final filePath = p.join((await _getPersistentPath(fileDir)).path, fileName);

  if (await File(filePath).exists()) {
    return await File(filePath).readAsString();
  }

  debugPrint("No file found at $filePath");
  return null;
}

Future<File> writeFile(String encodedJsonData, List<String> fileDir, String fileName) async {
  final filePath = p.join((await _getPersistentPath(fileDir)).path, fileName);

  final file = File(filePath);
  return file.writeAsString(encodedJsonData);
}

void deleteFile(List<String> fileDir, String fileName) async {
  final filePath = p.join((await _getPersistentPath(fileDir)).path, fileName);

  final file = File(filePath);
  if (await file.exists()) {
    file.delete();
  }
}
