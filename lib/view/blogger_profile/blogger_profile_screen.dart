import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_blog_project/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import '../../resources/resources.dart';
import '../../widget/widget.dart';
import 'blogger_profile_provider.dart';

class BloggerProfileScreen extends ConsumerStatefulWidget {
  const BloggerProfileScreen({super.key});

  @override
  ConsumerState<BloggerProfileScreen> createState() => _BloggerProfileScreenState();
}

class _BloggerProfileScreenState extends ConsumerState<BloggerProfileScreen> {
  ValueNotifier<bool> loading = ValueNotifier(true); // to manage the focus

  @override
  void initState() {
    super.initState();
    ref.read(userDataList.notifier).getUser().then((value) {
      loading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataList);
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: StringManager.userProfileAppBarTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.w),
          child: ValueListenableBuilder(
            valueListenable: loading,
            builder: (context, value, child) {
              return value
                  ? const Center(
                      child: SpinKitFoldingCube(
                        color: Colors.black,
                        size: 45,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(44.w), // Image radius
                                child: CachedNetworkImage(
                                  imageUrl: userData.first.userData!.profileUrl!,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.account_circle_outlined,
                                    size: 78.h,
                                    color: ColorManager.greyColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0.r, top: 14.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData.first.userData!.userName!,
                                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      userData.first.userData!.email!,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: ColorManager.greyColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.r),
                          child: Text(
                            "Bio",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.r),
                          child: Text(
                            userData.first.userData!.bio!,
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              log("press edit profile");
                              context.push(RoutesName.editProfileScreen);
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.edit),
                              title: const Text("Edit Profile"),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 25.h,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              log("Log out");
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.notes_rounded),
                              title: const Text("Projects"),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 25.h,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              log("Log out");
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.logout_rounded),
                              title: const Text("LogOut"),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 25.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
