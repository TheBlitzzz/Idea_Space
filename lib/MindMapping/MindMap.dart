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

part 'ToolWidgets.dart';

part 'MindMapModel.dart';

part 'MindMap.g.dart';

const double _borderRadius = 10, _buttonSize = 30;
const _animDuration = Duration(milliseconds: 100);
const Color _toolOutlineColour = Colors.blue;
