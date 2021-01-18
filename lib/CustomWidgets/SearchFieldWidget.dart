part of custom_widgets;

class SearchField extends StatelessWidget {
  final TextEditingController _controller;
  final void Function({String searchTerm}) _searchFile;

  String get getText => _controller.text;

  SearchField(this._controller, this._searchFile);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(_borderRadius)),
        hintStyle: TextStyle(color: Colors.grey[500]),
        hintText: "Search",
        contentPadding: EdgeInsets.all(10),
        prefixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _searchFile(),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _controller.text = "";
            _searchFile();
          },
        ),
      ),
      onChanged: (searchTerm) => _searchFile(searchTerm: searchTerm),
    );
  }
}
