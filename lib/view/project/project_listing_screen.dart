import 'package:final_blog_project/routes/routes_name.dart';
import 'package:final_blog_project/services/services.dart';
import 'package:final_blog_project/view/project/project_listing_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../model/project_model.dart';
import '../../resources/resources.dart';
import '../../widget/widget.dart';

class UserProjectListing extends ConsumerStatefulWidget {
  const UserProjectListing({super.key});

  @override
  ConsumerState<UserProjectListing> createState() => _UserProjectListingState();
}

class _UserProjectListingState extends ConsumerState<UserProjectListing> {
  Future<void> update() async {
    await ref.read(projectList.notifier).getUserProject();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: update,
                  child: Consumer(
                    builder: (context, ref, child) {
                      return FutureBuilder(
                        future: ref.read(projectList.notifier).getUserProject(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final projectData = snapshot.data as List<ProjectModel>;

                            return Expanded(
                              child: ListView.builder(
                                itemCount: projectData.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        context.push(
                                          RoutesName.projectDetailsScreen,
                                          extra: ProjectDetailsModel(
                                            currentUserId: UserPreferences.userId!,
                                            projectData: projectData[index],
                                          ),
                                        );
                                      },
                                      title: TextRich(
                                        firstText: "Title : ",
                                        secText: "${projectData[index].title}",
                                        style1: TextStyle(
                                            color: ColorManager.gradientDarkTealColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                        style2: TextStyle(
                                          color: ColorManager.blackColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      subtitle: TextRich(
                                        firstText: "Link\t:\t",
                                        secText: "${projectData[index].projectUrl}",
                                        style1: TextStyle(
                                            color: ColorManager.gradientDarkTealColor,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500),
                                        style2: TextStyle(
                                            color: ColorManager.blurColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.underline),
                                      ),
                                      trailing: Icon(
                                        Icons.chevron_right_rounded,
                                        size: 25.h,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(
            RoutesName.addProjectScreen,
            extra: EditProject(
              projectDetailsScreen: false,
            ),
          );
        },
        child: Image.asset(IconAssets.addProjectIcon,height: 25.h,)
      ),
    );
  }
}
