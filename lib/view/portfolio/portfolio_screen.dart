import 'package:final_blog_project/resources/resources.dart';
import 'package:final_blog_project/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../widget/widget.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: StringManager.portfolioAppBarTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigation to the see the profile
                  // context.push(
                  //   RoutesName.bloggerProfileScreen,
                  //   extra: BloggerProfileData(
                  //     portfolioScreen: false,
                  //     data: data[index],
                  //   ),
                  // );
                },
                child: Card(
                  elevation: 10,
                  color: ColorManager.whiteColor,
                  child: Row(
                    children: [
                      Container(
                        width: 110.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              "https://c4.wallpaperflare.com/wallpaper/384/350/430/digital-art-artwork-cyber-cyberpunk-neon-hd-wallpaper-preview.jpg",
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.w),
                            topLeft: Radius.circular(10.w),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(11.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Yojit Sutradahr",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "yojit Sutradhar@gmail.com",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${StringManager.projectTxt}: 10",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
