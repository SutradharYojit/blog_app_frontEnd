import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:final_blog_project/data/blog_data_list.dart';
import 'package:final_blog_project/services/api_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/model.dart';
import '../../resources/resources.dart';
import '../../services/services.dart';
import '../../widget/widget.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({
    super.key,
    required this.blogContent,
  });

  final BlogPreferences blogContent;

  //Getting the blog Data from the list of the blogs

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final ValueNotifier<List> _tagsList = ValueNotifier([]);
  ValueNotifier<String> imgUrl = ValueNotifier(""); // to manage the focus

  File? imageFile;
  final bar = WarningBar();
  String dropdownValue = 'Lifestyle';


  @override
  void initState() {
    super.initState();
    // the condition check while data is coming from blog list screen and used to update the blog data
    if (widget.blogContent.blogChoice) {
      imgUrl.value = widget.blogContent.blogData!.blogImgUrl!;
      _titleController.text = widget.blogContent.blogData!.title!;
      dropdownValue = widget.blogContent.blogData!.categories!;
      _tagsList.value = widget.blogContent.blogData!.tags!;
      _descriptionController.text = widget.blogContent.blogData!.description!;
    }
  }

  Future<String> uploadImage() async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final File? image = imageFile;
      var random = Random.secure();
      var values = List<int>.generate(20, (i) => random.nextInt(255));
      String imageName = base64UrlEncode(values);
      final String imagePath = 'blogsImages/${UserPreferences.userId}/$imageName';
      UploadTask uploadTask = storage.ref().child(imagePath).putFile(image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print(e);
      return "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        title: AppBarTitle(
          title: widget.blogContent.blogChoice
              ? StringManager.updateBlogTxt
              : StringManager.addBlogTxt, //check weather its should be add blog or update blog
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              children: [
                Center(
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12.r),
                    padding: EdgeInsets.all(6.r),
                    dashPattern: const [7, 3],
                    strokeWidth: 1,
                    // child: ClipRRect(
                    //   borderRadius: BorderRadius.all(
                    //     Radius.circular(12.r),
                    //   ),
                    //   child: imageFile != null
                    //       ? SizedBox(
                    //     height: 170.h,
                    //     width: double.infinity,
                    //     child: Image.file(
                    //       imageFile!,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   )
                    //       : Container(
                    //     height: 170.h,
                    //     width: double.infinity,
                    //     color: ColorManager.tealColor,
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         IconButton(
                    //           splashColor: Colors.teal,
                    //           onPressed: () async {
                    //             final image = await picker.pickImage(
                    //               source: ImageSource.gallery,
                    //             );
                    //             setState(() {
                    //               imageFile = File(image!.path);
                    //             });
                    //             final imageUrl=await uploadImage();
                    //             imgUrl.value=imageUrl;
                    //             dev.log(imageUrl.toString());
                    //           },
                    //           icon: Icon(
                    //             Icons.add_circle_outline,
                    //             size: 50.h,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    child: Stack(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: imgUrl,
                          builder: (context, value, child) {
                            return SizedBox(
                              height: 170.h,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.w),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: value,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Image.asset(
                                      IconAssets.blankImgIcon,
                                      height: 60.h,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Visibility(
                            visible: true,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: ColorManager.greyColor, borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                onPressed: () async {
                                  await picker
                                      .pickImage(
                                    source: ImageSource.gallery,
                                  )
                                      .then((image) async {
                                    dev.log(image.toString());
                                    if (image != null) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                            child: Loading(),
                                          );
                                        },
                                      );
                                      setState(() {
                                        imageFile = File(image!.path);
                                      });
                                      final imageUrl = await uploadImage();
                                      imgUrl.value = imageUrl;
                                      Navigator.pop(context);
                                      dev.log(imgUrl.value);
                                    }
                                  });
                                },
                                icon: Center(
                                  child: Icon(
                                    Icons.camera,
                                    size: 18.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.r),
                  child: PrimaryTextFilled(
                    controller: _titleController,
                    hintText: StringManager.titleHintTxt,
                    labelText: StringManager.titleLabelTxt,
                    prefixIcon: const Icon(
                      Icons.title,
                      color: ColorManager.gradientDarkTealColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0.r),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: buildOutlineInputBorder(),
                      focusedBorder: buildOutlineInputBorder(),
                    ),
                    value: BlogDataList.blogCategory[0],
                    onChanged: (String? newValue) {
                      dev.log(newValue.toString());
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: BlogDataList.blogCategory.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _tagsList,
                  builder: (context, data, child) {
                    return Padding(
                      padding: EdgeInsets.only(top: 10.r),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 1,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("#${data[index]}"),
                                InkWell(
                                  onTap: () {
                                    dev.log("onTap");
                                    _tagsList.value.removeAt(index);
                                    setState(() {});
                                  },
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: ColorManager.grey300Color,
                                    child: Icon(
                                      Icons.close,
                                      size: 13.h,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.r),
                  child: PrimaryTextFilled(
                    controller: _tagsController,
                    hintText: StringManager.hashHintTxt,
                    labelText: StringManager.hashLabelTxt,
                    onFieldSubmitted: (p0) {
                      _tagsList.value.insert(0, _tagsController.text.trim());
                      _tagsController.clear();
                    },
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(
                      Icons.tag,
                      color: ColorManager.tealColor,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.r),
                  child: PrimaryTextFilled(
                    controller: _descriptionController,
                    hintText: StringManager.descHintTxt,
                    labelText: StringManager.descLabelTxt,
                    prefixIcon: const Icon(
                      Icons.title,
                      color: ColorManager.gradientDarkTealColor,
                    ),
                  ),
                ),
                PrimaryButton(
                  title: widget.blogContent.blogChoice ? StringManager.updateBlogTxt : StringManager.addBlogTxt,
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: Loading(),
                        );
                      },
                    );
                    if (widget.blogContent.blogChoice){
                      ApiServices().postApi(
                        api: "${APIConstants.baseUrl}blog/updateBlog",
                        body: {
                          "title": _titleController.text.trim(),
                          "description": _descriptionController.text.trim(),
                          "categories": dropdownValue,
                          "tags": _tagsList.value,
                          "blogImgUrl": imgUrl.value,
                          "id":widget.blogContent.blogData!.id!
                        },
                      ).then(
                            (value) {
                          dev.log("Success");
                          dev.log(value["success"].toString());
                          final addBlog = bar.snack(StringManager.updateBlogTxt, ColorManager.greenColor);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(addBlog);
                          Navigator.pop(context);
                        },
                      );
                    }else{
                      ApiServices().postApi(
                        api: "${APIConstants.baseUrl}blog/createBlog",
                        body: {
                          "title": _titleController.text.trim(),
                          "description": _descriptionController.text.trim(),
                          "categories": dropdownValue,
                          "tags": _tagsList.value,
                          "blogImgUrl": imgUrl.value,
                          "userId": UserPreferences.userId
                        },
                      ).then(
                            (value) {
                          dev.log("Success");
                          dev.log(value["success"].toString());
                          _titleController.clear();
                          _descriptionController.clear();
                          _tagsList.value.clear();
                          imgUrl.value = "";
                          setState(() {});
                          final addBlog = bar.snack(StringManager.addBlogSuccessTxt, ColorManager.greenColor);

                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(addBlog);
                          Navigator.pop(context);
                        },
                      );
                    }

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
