part of custom_widgets;

class ExpandableBox extends StatefulWidget {
  final double titleHeight;
  final double spacing;
  final List<BoxItem> items;
  final String title;
  final CrossAxisAlignment childAlignment;

  int get fieldCount => items.length + 1;

  ExpandableBox(this.titleHeight, this.spacing, this.items, this.title,
      {this.childAlignment = CrossAxisAlignment.start});

  @override
  _ExpandableBoxState createState() {
    double totalHeight = titleHeight;
    items.forEach((element) {
      totalHeight += element.height + spacing;
    });
    return _ExpandableBoxState(totalHeight);
  }
}

class _ExpandableBoxState extends State<ExpandableBox> with TickerProviderStateMixin {
  static const double padding = 10;
  static const int animDurationMilliseconds = 250;

  final double totalHeight;

  double rotEnd = -Math.pi / 2;
  double rotBegin = 0;

  bool isExpanded = false;

  _ExpandableBoxState(this.totalHeight);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var spacing = SizedBox(height: widget.spacing);
    var title = InkWell(
      child: Row(
        children: [
          _createDropDownArrow(),
          SizedBox(width: 20),
          Text(widget.title, textAlign: TextAlign.center),
        ],
      ),
      onTap: _checkExpanded,
    );

    List<Widget> children = [title];
    if (isExpanded) {
      children.add(spacing);
      widget.items.forEach((element) {
        children.add(Container(
          height: element.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: element.bgColour,
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: element.widget,
        ));
      });
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: animDurationMilliseconds),
      padding: EdgeInsets.all(padding),
      height: (isExpanded ? totalHeight : widget.titleHeight) + padding * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: Color.fromARGB(255, 27, 27, 47),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: widget.childAlignment,
          children: children,
        ),
      ),
    ).pad(padding, padding, padding / 2, padding / 2);
  }

  Widget _createDropDownArrow() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: animDurationMilliseconds),
      tween: Tween<double>(begin: rotBegin, end: rotEnd),
      child: Icon(Icons.arrow_drop_down_circle_outlined),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value,
          child: child,
        );
      },
    );
  }

  void _checkExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        rotBegin = -Math.pi / 2;
        rotEnd = 0;
      } else {
        rotEnd = -Math.pi / 2;
        rotBegin = 0;
      }
    });
  }
}

class BoxItem {
  Widget widget;
  double height;
  Color bgColour;

  BoxItem({this.widget, this.height, this.bgColour});
}
