class InboxMessageResoponse {
  int? status;
  String? message;
  InboxMessageData? data;

  InboxMessageResoponse({this.status, this.message, this.data});

  InboxMessageResoponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? InboxMessageData.fromJson(json['data']) : null;
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

class InboxMessageData {
  List<Admins>? admins;
  List<Messages>? messages;
  int? unreadCount;

  InboxMessageData({this.admins, this.messages, this.unreadCount});

  InboxMessageData.fromJson(Map<String, dynamic> json) {
    if (json['admins'] != null) {
      admins = <Admins>[];
      json['admins'].forEach((v) {
        admins!.add(Admins.fromJson(v));
      });
    }
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    unreadCount = json['unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (admins != null) {
      data['admins'] = admins!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    data['unread_count'] = unreadCount;
    return data;
  }
}

class Admins {
  String? id;
  String? firstname;
  String? middlename;
  String? lastname;
  String? username;
  String? password;
  String? status;
  String? type;
  String? dateUpdated;
  String? name;

  Admins(
      {this.id,
      this.firstname,
      this.middlename,
      this.lastname,
      this.username,
      this.password,
      this.status,
      this.type,
      this.dateUpdated,
      this.name});

  Admins.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    middlename = json['middlename'];
    lastname = json['lastname'];
    username = json['username'];
    password = json['password'];
    status = json['status'];
    type = json['type'];
    dateUpdated = json['date_updated'];
    name = json['name'];
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
    data['name'] = name;
    return data;
  }
}

class Messages {
  String? id;
  String? sentTo;
  String? sentBy;
  String? messageContent;
  String? isRead;
  String? createdAt;
  String? senderName;
  String? senderType;

  Messages(
      {this.id,
      this.sentTo,
      this.sentBy,
      this.messageContent,
      this.isRead,
      this.createdAt,
      this.senderName,
      this.senderType});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sentTo = json['sent_to'];
    sentBy = json['sent_by'];
    messageContent = json['message_content'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    senderName = json['sender_name'];
    senderType = json['sender_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sent_to'] = sentTo;
    data['sent_by'] = sentBy;
    data['message_content'] = messageContent;
    data['is_read'] = isRead;
    data['created_at'] = createdAt;
    data['sender_name'] = senderName;
    data['sender_type'] = senderType;
    return data;
  }
}