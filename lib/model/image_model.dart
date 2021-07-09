class ImageModel {
  String? contentType;
  String? extension;
  String? name;
  String? size;
  String? path;

  ImageModel({
      this.contentType, 
      this.extension, 
      this.name, 
      this.size, 
      this.path});

  ImageModel.fromJson(dynamic json) {
    contentType = json["contentType"];
    extension = json["extension"];
    name = json["name"];
    size = json["size"];
    path = json["path"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["contentType"] = contentType;
    map["extension"] = extension;
    map["name"] = name;
    map["size"] = size;
    map["path"] = path;
    return map;
  }

}