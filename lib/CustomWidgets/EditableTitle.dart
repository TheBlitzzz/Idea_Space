part of custom_widgets;

class EditableTitle extends StatefulWidget {
  final void Function(String) changeTitle;
  final String title;

  EditableTitle(this.changeTitle, this.title);

  @override
  _EditableTitleState createState() => _EditableTitleState();
}

class _EditableTitleState extends State<EditableTitle> {
  final TextEditingController _controller = new TextEditingController();
  bool isEditing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEditing ? _createTextField() : _createGestureDetector();
  }

  Widget _createTextField() {
    return TextField(
      autofocus: true,
      controller: _controller..text = widget.title,
      decoration: InputDecoration(border: InputBorder.none, hintText: 'Title'),
      onSubmitted: (value) {
        _toggleEdit();
        widget.changeTitle(value);
      },
    );
  }

  Widget _createGestureDetector() {
    return GestureDetector(
      onLongPress: _toggleEdit,
      child: Text(widget.title, style: TextStyle(color: Colors.white)),
    );
  }

  void _toggleEdit() {
    setState(() => isEditing = !isEditing);
  }
}
