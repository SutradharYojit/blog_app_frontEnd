import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_blog_project/services/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/model.dart';
import '../../resources/resources.dart';
import '../../services/services.dart';
import '../../widget/widget.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.blogId});

  final String blogId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentCtrl = TextEditingController();

  ValueNotifier<List<CommentModel>> commentData = ValueNotifier([]);

  Future<List<CommentModel>> getComments() async {
    final List<CommentModel> bloggersList = [];
    bloggersList.clear();
    final data = await ApiServices().getApi(
      api: "${APIConstants.baseUrl}comment/getComment",
      body: {"blogId": widget.blogId},
    );
    for (Map<String, dynamic> i in data) {
      bloggersList.add(CommentModel.fromJson(i));
    }
    return bloggersList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Comments"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              FutureBuilder(
                future: getComments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    commentData.value = snapshot.data as List<CommentModel>;
                    return ValueListenableBuilder(
                      valueListenable: commentData,
                      builder: (context, value, child) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(25.w), // Image radius
                                    child: CachedNetworkImage(
                                      imageUrl: value[index].user!.profileUrl!,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(ImageAssets.blankProfileImg),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  value[index].user!.userName!,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  value[index].comment!,
                                  style: TextStyle(color: ColorManager.grey500Color),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.0.w),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryTextFilled(
                        controller: _commentCtrl,
                        hintText: StringManager.commentHintTxt,
                        labelText: StringManager.commentLabelTxt,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            IconAssets.commentIcon,
                            height: 0.h,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            ApiServices().postApi(
                              api: "${APIConstants.baseUrl}comment/addComment",
                              body: {
                                "description": _commentCtrl.text.trim(),
                                "blogId": widget.blogId,
                                "userId": UserPreferences.userId
                              },
                            ).then(
                              (data) {
                                log(data.toString());
                                Fluttertoast.showToast(
                                    msg: 'Comment added',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.yellow);
                                // commentData.value.insert(0, CommentModel.fromJson(data));
                                for (Map<String, dynamic> i in data) {
                                  commentData.value.insert(0, CommentModel.fromJson(i));
                                }
                                setState(() {});
                              },
                            );
                          },
                          icon: CircleAvatar(
                            backgroundColor: ColorManager.rgbWhiteColor,
                            radius: 25,
                            child: Image.asset(IconAssets.sendIcon, height: 20.h),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
