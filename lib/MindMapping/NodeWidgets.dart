part of mind_map;

const double _outlineWidth = 3;

class _PageNode extends StatelessWidget {
  final PageNodeModel node;
  final bool isSelected;
  final void Function(int) selectFunc;

  _PageNode(this.node, this.isSelected, this.selectFunc);

  @override
  Widget build(BuildContext context) {
    Offset position = node.getPosition;
    return Positioned(
      child: _createNodeWidget(),
      top: position.dy,
      left: position.dx,
      height: node.size.height,
      width: node.size.width,
    );
  }

  //region UI
  Widget _createNodeWidget() {
    return GestureDetector(
      child: Container(
        child: Text(node.title).align(Alignment.center),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
          border: isSelected ? Border.all(width: _outlineWidth, color: _toolOutlineColour) : null,
        ),
      ),
      onTap: () => selectFunc(node.id),
    );
  }
//endregion
}

class _TextNode extends StatelessWidget {
  final TextNodeModel node;
  final bool isSelected;
  final void Function(int) selectFunc;
  final TextEditingController controller;

  _TextNode(this.node, this.isSelected, this.selectFunc, this.controller);

  @override
  Widget build(BuildContext context) {
    Offset position = node.getPosition;
    return Positioned(
      child: _createText(() => showEditDialog(context)),
      top: position.dy,
      left: position.dx,
      width: node.size.width,
      height: node.size.height,
    );
  }

  //isSelected ? _createTextField() :

  //region UI
  Widget _createText(Function() showEditDialog) {
    return GestureDetector(
      child: Container(
        child: Text(
          node.title,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          color: isSelected ? Colors.grey[600] : null,
          border: isSelected ? Border.all(width: _outlineWidth, color: _toolOutlineColour) : null,
        ),
        alignment: Alignment.center,
      ),
      onTap: () {
        selectFunc(node.id);
        if (isSelected) {
          showEditDialog();
        }
      },
    );
  }

  void showEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Text"),
            content: _createTextField(),
            actions: [
              FlatButton(
                child: Text('Save'),
                onPressed: () {
                  node.title = controller.text;
                  selectFunc(null);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  Widget _createTextField() {
    return Container(
      child: TextField(
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        controller: controller..text = node.title,
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(_borderRadius))),
      ),
    );
  }
//endregion
}
