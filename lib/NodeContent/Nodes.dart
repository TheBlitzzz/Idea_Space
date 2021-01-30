library nodes;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:idea_space/IOHandler/IOHandler.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'package:idea_space/zExtensions/WidgetTransforms.dart';
import 'package:idea_space/CustomWidgets/CustomWidgets.dart';
import '../Homepage/Homepage.dart';
import 'package:idea_space/MindMapping/MindMap.dart';

part 'BaseNode.dart';

part 'NodeModels.dart';

part 'NodeEditorPage.dart';

part 'Nodes.g.dart';

const double _borderRadius = 10, _outlineWidth = 3;
const Color _toolOutlineColour = Colors.blue;
