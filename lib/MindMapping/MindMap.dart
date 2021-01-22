library mind_map;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:idea_space/CustomWidgets/CustomWidgets.dart';
import 'package:idea_space/IOHandler/IOHandler.dart';
import 'package:idea_space/NodeContent/Nodes.dart';
import 'package:idea_space/zExtensions/WidgetTransforms.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Editor.dart';

part 'NodeFactory.dart';

part 'LinkDrawer.dart';

part 'ToolWidgets.dart';

part 'MindMapModel.dart';

part 'MindMap.g.dart';

const double _borderRadius = 10, _buttonSize = 30, _outlineWidth = 3;
const _animDuration = Duration(milliseconds: 100);
const Color _toolOutlineColour = Colors.blue;

Color get _defaultNodeColour => Colors.grey[700];

Color get _bgColour => Colors.grey[850];

const Size _defaultNodeSize = Size(120, 40);
