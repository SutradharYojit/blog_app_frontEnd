import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_blog_project/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../model/model.dart';
import '../../resources/resources.dart';
import '../../routes/routes_name.dart';
import '../../widget/widget.dart';
import 'blog_listing_provider.dart';

enum EditAuth {
  edit,
  delete,
}

class BlogListingScreen extends ConsumerStatefulWidget {
  const BlogListingScreen({super.key});

  @override
  ConsumerState<BlogListingScreen> createState() => _BlogListingScreenState();
}

class _BlogListingScreenState extends ConsumerState<BlogListingScreen> with SingleTickerProviderStateMixin {
  EditAuth? selectedItem;
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final Animation<Offset> position = Tween<Offset>(
    begin: const Offset(10, 0),
    end: const Offset(0, 0),
  ).animate(
    CurvedAnimation(parent: _animationController, curve: Curves.linear),
  );

  Future<void> getData() async {
    await ref.read(blogDataList.notifier).getBlogs();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 1000) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final blogList = ref.watch(blogDataList);
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: StringManager.blogsAppBarTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.w),
          child: RefreshIndicator(
            onRefresh: ref.read(blogDataList.notifier).getBlogs,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                blogList.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            Image.asset(IconAssets.blankImgIcon, height: 60.h),
                            const Text(StringManager.emptyBlogTxt)
                          ],
                        ),
                      )
                    : Expanded(
                        child: Stack(
                          children: [
                            ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 15.w),
                              itemCount: blogList.length,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    context.push(RoutesName.blogDetailsScreen, extra: blogList[index]);
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
                                                    visible: UserPreferences.userId == blogList[index].userId,
                                                    // When edit update functionality is enabled when the authorId and CurrentUser Id will be match
                                                    child: PopupMenuButton(
                                                      initialValue: selectedItem,
                                                      onSelected: (EditAuth item) {
                                                        if (item == EditAuth.edit) {
                                                          context.push(
                                                            RoutesName.addBlogScreen,
                                                            //pass the blag data to add blog screen
                                                            extra: BlogPreferences(
                                                              blogChoice: true,
                                                              blogData: blogList[index],
                                                            ),
                                                          );
                                                        } else {
                                                          // function to delete the blog
                                                          ref
                                                              .read(blogDataList.notifier)
                                                              .blogDelete(blogList[index].id!, index);
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
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12.w),
                                                child: CachedNetworkImage(
                                                    imageUrl: blogList[index].blogImgUrl!,
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                        Center(
                                                          child: CircularProgressIndicator(
                                                            value: downloadProgress.progress,
                                                          ),
                                                        ),
                                                    errorWidget: (context, url, error) => Center(
                                                          child: Image.asset(
                                                            IconAssets.blankImgIcon,
                                                            height: 60.h,
                                                          ),
                                                        )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 7.w),
                                                child: Text(
                                                  blogList[index].title!,
                                                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0),
                                                child: Container(
                                                  constraints: BoxConstraints(minHeight: 30.h, maxHeight: 75.h),
                                                  child: Text(
                                                    blogList[index].description!,
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
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
                                );
                              },
                            ),
                            //scroll animation

                            Positioned(
                              bottom: 15.h,
                              right: 0.h,
                              child: UpAnimation(position: position, scrollController: _scrollController),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
