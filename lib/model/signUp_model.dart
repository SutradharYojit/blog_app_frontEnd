class SignUpModel {
  String? message;
  bool? success;
  Result? result;

  SignUpModel({this.message, this.success, this.result});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? id;
  String? userName;
  String? email;
  String? password;
  String? updatedAt;
  String? createdAt;
  String? profileUrl;

  Result(
      {this.id,
        this.userName,
        this.email,
        this.password,
        this.updatedAt,
        this.createdAt,
        this.profileUrl});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    profileUrl = json['profileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['profileUrl'] = this.profileUrl;
    return data;
  }
}
