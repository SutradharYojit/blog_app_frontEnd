import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../resources/resources.dart';
import '../../routes/routes_name.dart';
import '../../widget/widget.dart';
enum EditAuth {
  edit,
  delete,
}
class BlogListingScreen extends StatelessWidget {
    BlogListingScreen({super.key});

  EditAuth? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: StringManager.blogsAppBarTitle),
      ),
      body:   SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(15.0.w),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  context.push(RoutesName.blogDetailsScreen);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    "Publish At".substring(0, 10),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: ColorManager.greyColor,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  // visible: UserGlobalVariables.uid == blogList[index].attributes!.authorId!,
                                  visible: true,
                                  // When edit update functionality is enabled when the authorId and CurrentUser Id will be match
                                  child: PopupMenuButton(
                                    initialValue: selectedItem,
                                    onSelected: (EditAuth item) {
                                      if (item == EditAuth.edit) {
                                        /*context.push(
                                          RoutesName.addBlogScreen,
                                          //pass the blag data to add blog screen
                                          extra: BlogPreferences(
                                              blogChoice: true,
                                              title: blogList[index].attributes!.title!,
                                              description: blogList[index].attributes!.description!,
                                              index: blogList[index].id!),
                                        );*/
                                      } else {
                                        // function to delete the blog
                                        /*ref
                                            .read(blogDataList.notifier)
                                            .blogDelete(blogList[index].id!, index);*/
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<EditAuth>>[
                                      const PopupMenuItem(
                                        value: EditAuth.edit,
                                        child: PopMenuBtn(
                                          title: StringManager.editTxt,
                                          icon: Icons.edit,
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: EditAuth.delete,
                                        child: PopMenuBtn(
                                          title: StringManager.deleteTxt,
                                          icon: Icons.delete_outline_rounded,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              // margin: EdgeInsets.symmetric(vertical: 10.r),
                              constraints: BoxConstraints(minHeight: 150.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    "https://c4.wallpaperflare.com/wallpaper/365/244/884/uchiha-itachi-naruto-shippuuden-anbu-silhouette-wallpaper-preview.jpg",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 7.w),
                              child: Text(
                                "title",
                                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                constraints: BoxConstraints(minHeight: 30.h, maxHeight: 75.h),
                                child: Text(
                                  "Description",
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
