library mind_map;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:idea_space/CustomWidgets/CustomWidgets.dart';
import '../Homepage/Homepage.dart';
import 'package:idea_space/IOHandler/IOHandler.dart';
import 'package:idea_space/NodeContent/Nodes.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

part 'Editor.dart';

part 'NodeFactory.dart';

part 'LinkDrawer.dart';

part 'ToolWidgets.dart';

part 'MindMapModel.dart';

part 'NodeColorPicker.dart';

part 'MindMap.g.dart';

const double _borderRadius = 10, _buttonSize = 30, _outlineWidth = 3;
const _animDuration = Duration(milliseconds: 100);
const Color _toolOutlineColour = Colors.blue;

Color get _defaultNodeColour => Colors.grey[700];

const Size _defaultNodeSize = Size(120, 40);
