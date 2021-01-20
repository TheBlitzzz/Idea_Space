library mind_map;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:idea_space/CustomWidgets/CustomWidgets.dart';
import 'package:idea_space/IOHandler/IOHandler.dart';
import 'package:idea_space/NodeContent/Nodes.dart';
import 'package:idea_space/zExtensions/WidgetTransforms.dart';

part 'Editor.dart';

part 'NodeWidgets.dart';

part 'NodeFactory.dart';

part 'NodeToolStack.dart';

const double _borderRadius = 10, _buttonSize = 30;
const _animDuration = Duration(milliseconds: 100);
const Color _toolOutlineColour = Colors.blue;
