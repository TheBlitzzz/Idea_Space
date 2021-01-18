part of custom_widgets;

class ExpandableBox extends StatefulWidget {
  final double fieldHeight;
  final List<Widget> children;
  final String title;
  final CrossAxisAlignment childAlignment;

  int get fieldCount => children.length + 1;

  ExpandableBox(this.fieldHeight, this.children, this.title, {this.childAlignment = CrossAxisAlignment.start});

  @override
  _ExpandableBoxState createState() => _ExpandableBoxState();
}

class _ExpandableBoxState extends State<ExpandableBox> with TickerProviderStateMixin {
  static const double padding = 10;
  static const int animDurationMilliseconds = 250;

  double end = -math.pi / 2;
  double begin = 0;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var title = InkWell(
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: animDurationMilliseconds),
            tween: Tween<double>(begin: begin, end: end),
            child: Icon(Icons.arrow_drop_down_circle_outlined),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value,
                child: child,
              );
            },
          ),
          SizedBox(width: 20),
          Text(widget.title, textAlign: TextAlign.center),
        ],
      ),
      onTap: _checkExpanded,
    );

    List<Widget> children = [title];
    if (isExpanded) {
      widget.children.forEach((element) {
        children.add(element);
      });
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: animDurationMilliseconds),
      padding: EdgeInsets.all(padding),
      height: widget.fieldHeight * (isExpanded ? widget.fieldCount : 1) + padding * 2,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 27, 27, 47)),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: widget.childAlignment,
          children: children,
        ),
      ),
    ).pad(padding, padding, padding / 2, padding / 2);
  }

  void _checkExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        begin = -math.pi / 2;
        end = 0;
      } else {
        end = -math.pi / 2;
        begin = 0;
      }
    });
  }
}
