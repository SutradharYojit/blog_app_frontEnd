import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_blog_project/resources/resources.dart';
import 'package:final_blog_project/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../model/model.dart';
import '../../services/api_constants.dart';
import '../../services/services.dart';
import '../../widget/widget.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  Future<List<BloggerPortfolio>> getBLoggers() async {
    final List<BloggerPortfolio> bloggersList = [];
    bloggersList.clear();
    final data = await ApiServices().getApi(
      api: "${APIConstants.baseUrl}userUpdate/getUserAll",
      body: {
        // "id": UserPreferences.userId,
        "userId": UserPreferences.userId,
      },
    );
    for (Map<String, dynamic> i in data) {
      bloggersList.add(BloggerPortfolio.fromJson(i));
    }
    return bloggersList;
  }

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
              FutureBuilder(
                future: getBLoggers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final bloggerData = snapshot.data as List<BloggerPortfolio>;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: bloggerData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                RoutesName.bloggerProfileScreen,
                                extra: bloggerData[index],
                              );
                            },
                            child: Card(
                              elevation: 10,
                              color: ColorManager.whiteColor,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 110.w,
                                    height: 80.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.w),
                                        topLeft: Radius.circular(10.w),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: bloggerData[index].profileUrl!,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                          child: CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                          ),
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
                                    padding: EdgeInsets.all(11.0.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bloggerData[index].userName!,
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
                                                bloggerData[index].email!,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
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
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
