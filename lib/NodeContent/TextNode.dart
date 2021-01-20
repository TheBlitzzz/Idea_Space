part of nodes;

@JsonSerializable()
class TextNodeModel extends BaseNodeModel {
  String textContent;

  TextNodeModel(int id, double width, double height, double dx, double dy)
      : super(id, "Untitled #$id", width, height, dx, dy);

  factory TextNodeModel.fromJson(Map<String, dynamic> json) => _$TextNodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextNodeModelToJson(this);
}

@JsonSerializable()
class PageNodeModel extends BaseNodeModel {
  // String title;

  PageNodeModel(int id, double width, double height, double dx, double dy)
      : super(id, "Untitled #$id", width, height, dx, dy);

  factory PageNodeModel.fromJson(Map<String, dynamic> json) => _$PageNodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageNodeModelToJson(this);
}
