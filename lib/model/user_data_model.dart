class UserDataModel {
  bool? success;
  UserData? userData;

  UserDataModel({this.success, this.userData});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? id;
  String? userName;
  String? email;
  String? password;
  String? profileUrl;
  String? bio;
  String? createdAt;
  String? updatedAt;

  UserData(
      {this.id,
        this.userName,
        this.email,
        this.password,
        this.profileUrl,
        this.bio,
        this.createdAt,
        this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    profileUrl = json['profileUrl']??"ok";
    bio = json['bio']??"";
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['profileUrl'] = this.profileUrl;
    data['bio'] = this.bio;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
