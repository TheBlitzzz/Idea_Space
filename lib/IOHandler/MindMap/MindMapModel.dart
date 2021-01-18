part of io_handler;

@JsonSerializable()
class MindMapModel {
  String title;
  DateTime lastEditTime;
  bool isBookMarked;

  String get getLastEditTime {
    String year = lastEditTime.year.toString();
    String month = lastEditTime.month.toString().padLeft(2, '0');
    String day = lastEditTime.day.toString().padLeft(2, '0');
    String hour = lastEditTime.hour.toString().padLeft(2, '0');
    String minute = lastEditTime.minute.toString().padLeft(2, '0');
    return "Last edit : $year-$month-$day $hour:$minute";
  }

  MindMapModel(this.title, this.lastEditTime, {this.isBookMarked = false});

  factory MindMapModel.fromJson(Map<String, dynamic> json) => _$MindMapModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapModelToJson(this);

  void updateLastEdit() {
    lastEditTime = DateTime.now();
  }

  void toggleBookmark() {
    isBookMarked = !isBookMarked;
  }

  void _rename(String newTitle) {
    title = newTitle;
  }
}
