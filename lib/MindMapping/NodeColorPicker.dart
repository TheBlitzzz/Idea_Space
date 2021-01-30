part of mind_map;

class NodeColorPicker {
  final Color originalColour;
  final void Function(Color) colourSetter;

  NodeColorPicker(this.originalColour, this.colourSetter);

  void showColorPicker(BuildContext context) {
    Color currentColour = Colors.grey[800];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: BlockPicker(
              onColorChanged: (color) => currentColour = color,
              pickerColor: Colors.grey[800],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                colourSetter(currentColour);
              },
            ),
          ],
        );
      },
    );
  }
}
