class UploadPhotoResponseModel {
  int? status;
  String? message;
  ImageData? data;

  UploadPhotoResponseModel({this.status, this.message, this.data});

  UploadPhotoResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ImageData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ImageData {
  Photos? photos;
  Photo? photo;

  ImageData({this.photos, this.photo});

  ImageData.fromJson(Map<String, dynamic> json) {
    photos = json['photos'] != null ? Photos.fromJson(json['photos']) : null;
    photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (photos != null) {
      data['photos'] = photos!.toJson();
    }
    if (photo != null) {
      data['photo'] = photo!.toJson();
    }
    return data;
  }
}

class Photos {
  List<String>? name;
  List<String>? type;
  List<String>? tmpName;
  List<int>? error;
  List<int>? size;

  Photos({this.name, this.type, this.tmpName, this.error, this.size});

  Photos.fromJson(Map<String, dynamic> json) {
    name = json['name'].cast<String>();
    type = json['type'].cast<String>();
    tmpName = json['tmp_name'].cast<String>();
    error = json['error'].cast<int>();
    size = json['size'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['tmp_name'] = tmpName;
    data['error'] = error;
    data['size'] = size;
    return data;
  }
}

class Photo {
  String? name;
  String? type;
  String? tmpName;
  int? error;
  int? size;

  Photo({this.name, this.type, this.tmpName, this.error, this.size});

  Photo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    tmpName = json['tmp_name'];
    error = json['error'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['tmp_name'] = tmpName;
    data['error'] = error;
    data['size'] = size;
    return data;
  }
}
