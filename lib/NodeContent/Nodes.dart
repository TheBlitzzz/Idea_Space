library nodes;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:idea_space/CustomWidgets/CustomWidgets.dart';
import 'package:idea_space/MindMapping/MindMap.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:idea_space/zExtensions/WidgetTransforms.dart';
import 'package:image_picker/image_picker.dart';

part 'BaseNode.dart';

part 'NodeModels.dart';

part 'NodeEditorPage.dart';

part 'NodeEditorPage1.dart';

part 'SettingsPage.dart';

part 'Nodes.g.dart';

const double _borderRadius = 10, _outlineWidth = 3;
const Color _toolOutlineColour = Colors.blue;

Color get _defaultNodeColour => Colors.grey[700];
