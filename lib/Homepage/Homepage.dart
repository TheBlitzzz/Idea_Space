library homepage;

import 'dart:ui';
import 'package:idea_space/MindMapping/MindMap.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:idea_space/CustomWidgets/CustomWidgets.dart';
import 'package:idea_space/MindMapping/MindMap.dart' as MindMap;
import 'package:idea_space/IOHandler/IOHandler.dart';
import 'package:idea_space/zExtensions/WidgetTransforms.dart';

part 'HomepageWidget.dart';

part 'Settings.dart';

const double _documentItemSize = 60;
const double _borderRadius = 10;

const _animDuration = Duration(milliseconds: 500);
