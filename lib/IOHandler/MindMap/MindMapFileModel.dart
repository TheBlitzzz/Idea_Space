part of io_handler;

@JsonSerializable()
class MindMapFileModel {
  String title;
  String username;
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

  String get fileName => title + ".txt";

  MindMapFileModel(this.title, this.username, this.lastEditTime, {this.isBookMarked = false});

  void updateLastEdit() => lastEditTime = DateTime.now();

  void toggleBookmark() => isBookMarked = !isBookMarked;

  void _rename(String newTitle) => title = newTitle;

  //region JSON
  factory MindMapFileModel.fromJson(Map<String, dynamic> json) => _$MindMapFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapFileModelToJson(this);
//endregion
}
