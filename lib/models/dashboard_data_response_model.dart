class DashBoardResponse {
  int? status;
  String? message;
  DashBoardUserData? data;

  DashBoardResponse({this.status, this.message, this.data});

  DashBoardResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DashBoardUserData.fromJson(json['data']) : null;
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

class DashBoardUserData {
  String? loginId;
  String? username;
  List<SalesmanTarget>? salesmanTarget;
  List<Attendance>? attendance;

  DashBoardUserData({this.loginId, this.username, this.salesmanTarget, this.attendance});

  DashBoardUserData.fromJson(Map<String, dynamic> json) {
    loginId = json['login_id'];
    username = json['username'];
    if (json['salesman_target'] != null) {
      salesmanTarget = <SalesmanTarget>[];
      json['salesman_target'].forEach((v) {
        salesmanTarget!.add(SalesmanTarget.fromJson(v));
      });
    }
    if (json['attendance'] != null) {
      attendance = <Attendance>[];
      json['attendance'].forEach((v) {
        attendance!.add(Attendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login_id'] = loginId;
    data['username'] = username;
    if (salesmanTarget != null) {
      data['salesman_target'] =
          salesmanTarget!.map((v) => v.toJson()).toList();
    }
    if (attendance != null) {
      data['attendance'] = attendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesmanTarget {
  String? salesmanId;
  String? assigned;
  String? completed;
  String? remaining;

  SalesmanTarget(
      {this.salesmanId, this.assigned, this.completed, this.remaining});

  SalesmanTarget.fromJson(Map<String, dynamic> json) {
    salesmanId = json['salesman_id'];
    assigned = json['assigned'];
    completed = json['completed'];
    remaining = json['remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['salesman_id'] = salesmanId;
    data['assigned'] = assigned;
    data['completed'] = completed;
    data['remaining'] = remaining;
    return data;
  }
}

class Attendance {
  String? id;
  String? subAdminId;
  String? loginTime;
  String? logoutTime;
  String? loginLocation;
  String? logoutLocation;
  String? deviceName;
  String? username;
  String? loginDateTime;
  String? logoutDateTime;

  Attendance(
      {this.id,
      this.subAdminId,
      this.loginTime,
      this.logoutTime,
      this.loginLocation,
      this.logoutLocation,
      this.deviceName,
      this.username,
      this.loginDateTime,
      this.logoutDateTime});

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subAdminId = json['sub_admin_id'];
    loginTime = json['login_time'];
    logoutTime = json['logout_time'];
    loginLocation = json['login_location'];
    logoutLocation = json['logout_location'];
    deviceName = json['device_name'];
    username = json['username'];
    loginDateTime = json['LoginDateTime'];
    logoutDateTime = json['LogoutDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sub_admin_id'] = subAdminId;
    data['login_time'] = loginTime;
    data['logout_time'] = logoutTime;
    data['login_location'] = loginLocation;
    data['logout_location'] = logoutLocation;
    data['device_name'] = deviceName;
    data['username'] = username;
    data['LoginDateTime'] = loginDateTime;
    data['LogoutDateTime'] = logoutDateTime;
    return data;
  }
}