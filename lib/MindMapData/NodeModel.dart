part of mind_map_data;

@JsonSerializable()
class NodeModel {
  double posX;
  double posY;

  double sizeX;
  double sizeY;

  String title;

  NodeModel(this.posX, this.posY, this.sizeX, this.sizeY, this.title);

  factory NodeModel.fromJson(Map<String, dynamic> json) => _$NodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$NodeModelToJson(this);
}
