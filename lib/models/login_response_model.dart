class LoginResponseModel {
  int? status;
  String? message;
  LoginUserData? data;

  LoginResponseModel({this.status, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LoginUserData.fromJson(json['data']) : null;
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

class LoginUserData {
  String? id;
  String? firstname;
  String? middlename;
  String? lastname;
  String? username;
  String? password;
  String? status;
  String? type;
  String? dateUpdated;

  LoginUserData(
      {this.id,
      this.firstname,
      this.middlename,
      this.lastname,
      this.username,
      this.password,
      this.status,
      this.type,
      this.dateUpdated});

  LoginUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    middlename = json['middlename'];
    lastname = json['lastname'];
    username = json['username'];
    password = json['password'];
    status = json['status'];
    type = json['type'];
    dateUpdated = json['date_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['middlename'] = middlename;
    data['lastname'] = lastname;
    data['username'] = username;
    data['password'] = password;
    data['status'] = status;
    data['type'] = type;
    data['date_updated'] = dateUpdated;
    return data;
  }
}