import 'dart:developer';
import 'package:final_blog_project/model/user_data_model.dart';
import 'package:final_blog_project/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_constants.dart';

final userDataList = StateNotifierProvider<UserData, List<UserDataModel>>((ref) => UserData());

class UserData extends StateNotifier<List<UserDataModel>> {
  UserData() : super([]);

  String? image;

  Future<void> getUser() async {
    await UserPreferences().getUserInfo();
    log(UserPreferences.userId.toString());
    state.clear();
    final data = await ApiServices().getApi(
      api: "${APIConstants.baseUrl}userUpdate/getUser",
      body: {
        "id": UserPreferences.userId,
      },
    );
    state.add(UserDataModel.fromJson(data));
    state = [...state];
    image = state.first.userData!.profileUrl!;
  }

  void update({required Map<String, dynamic> data}) async {
    state.first.userData!.userName = data["userName"];
    state.first.userData!.email = data["email"];
    state.first.userData!.bio = data["bio"];
    state.first.userData!.profileUrl = data["profileUrl"];
    image = state.first.userData!.profileUrl!;

    await ApiServices().postApi(
      api: "${APIConstants.baseUrl}userUpdate/updateProfile",
      body: data,
    ).then((value) {
      log(value.toString());
    });

    state = [...state];
  }
}
