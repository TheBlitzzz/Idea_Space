import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NodeColorPicker extends StatefulWidget {
  @override
  _NodeColorPickerState createState() => _NodeColorPickerState();
}

class _NodeColorPickerState extends State<NodeColorPicker> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  Color oriColor = Color(0xff443a49);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: InkWell(onTap: ShowColorPicker,), color: pickerColor,),

      appBar: AppBar(
        title: Text("ColorPicker"),
      ),
    );

  }
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void ShowColorPicker() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          // child: ColorPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true,
          //   pickerAreaHeightPercent: 0.8,
          // ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          child: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
          ),
        ),
          //
        //   child: MultipleChoiceBlockPicker(
        //     pickerColors: pickerColors,
        //     onColorsChanged: changeColor,
        //   ),
        // ),
        actions: <Widget>[
          FlatButton(
            child: const Text('OK'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('Reset'),
            onPressed: () {
              setState(() => currentColor = oriColor);
              // Navigator.of(context).pop();
            },
          )  ,


        ],
      ),
    );
  }
}





