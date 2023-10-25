import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer'as dev;
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../resources/resources.dart';
import '../../services/services.dart';
import '../../widget/widget.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({
    super.key,

  });

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
  File? imageFile;
  final bar = WarningBar();
  String dropdownValue = 'Lifestyle';

    List<String> blogCategory = [
    "Lifestyle",
    "Health and Wellness",
    "Food and Cooking",
    "Travel",
    "Personal Finance",
    "Technology",
    "Parenting",
    "Fashion and Beauty",
    "Home Decor and DIY",
    "Business and Entrepreneurship",
  ];


  @override
  void initState() {
    super.initState();
    // the condition check while data is coming from blog list screen and used to update the blog data
    // if (widget.blogPreference.blogChoice) {
    //   _titleController.text = widget.blogPreference.title!;
    //   _descriptionController.text = widget.blogPreference.description!;
    // }
  }
  Future<String> uploadImage() async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final File? image = imageFile;
      var random = Random.secure();
      var values = List<int>.generate(20, (i) => random.nextInt(255));
      String imageName = base64UrlEncode(values);
      final String imagePath =
          'blogsImages/${UserPreferences.userId}/$imageName';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          title: "Add BLog", //check weather its should be add blog or update blog
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.r),
                      ),
                      child: imageFile != null
                          ? SizedBox(
                        height: 170.h,
                        width: double.infinity,
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        height: 170.h,
                        width: double.infinity,
                        color: ColorManager.tealColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              splashColor: Colors.teal,
                              onPressed: () async {
                                final image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                setState(() {
                                  imageFile = File(image!.path);
                                });
                                final imageUrl=await uploadImage();
                                dev.log(imageUrl.toString());
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                size: 50.h,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                  padding:   EdgeInsets.only(top: 15.0.r),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: buildOutlineInputBorder(),
                      focusedBorder: buildOutlineInputBorder(),
                    ),
                    value: blogCategory[0],
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: blogCategory.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20),
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
                  title: "Add Project",
                  onTap: () async {
                    // WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                    // if (_titleController.text.trim() == "" ||
                    //     _titleController.text.trim().isEmpty ||
                    //     _descriptionController.text.trim() == "" ||
                    //     _descriptionController.text.trim().isEmpty) {
                    //   // through the error snack bar when one of the text filled is empty
                    //   requiredAllFilled(context);
                    // } else {
                    //   final addBlog = bar.snack(ApiServiceManager.blogAdd, ColorManager.greenColor);
                    //   final updateBlog = bar.snack(ApiServiceManager.blogUpdate, ColorManager.greenColor);
                    //   // Loading screen
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return const Center(
                    //         child: Loading(),
                    //       );
                    //     },
                    //   );
                    //   // condition is invoke when the data is pas through from blog details screen
                    //   if (widget.blogPreference.blogChoice) {
                    //     // function to update the existing blog
                    //     ApiServices().editBlogData(
                    //       {
                    //         ApiServiceManager.apiTitleKey: _titleController.text.trim(),
                    //         ApiServiceManager.apiDescriptionKey: _descriptionController.text.trim(),
                    //         ApiServiceManager.apiAuthorKey: UserGlobalVariables.uid!.toString(),
                    //         ApiServiceManager.apiImageUrlKey:
                    //         "https://c4.wallpaperflare.com/wallpaper/410/867/750/vector-forest-sunset-forest-sunset-forest-wallpaper-preview.jpg"
                    //       },
                    //       widget.blogPreference.index!,
                    //     ).then((value) {
                    //       Navigator.pop(context);
                    //       ScaffoldMessenger.of(context).showSnackBar(updateBlog);
                    //     });
                    //   } else {
                    //     //function to add blog data
                    //     ApiServices().addBlogData(
                    //       {
                    //         ApiServiceManager.apiTitleKey: _titleController.text.trim(),
                    //         ApiServiceManager.apiDescriptionKey: _descriptionController.text.trim(),
                    //         ApiServiceManager.apiAuthorKey: UserGlobalVariables.uid!.toString(),
                    //         ApiServiceManager.apiImageUrlKey:
                    //         "https://c4.wallpaperflare.com/wallpaper/410/867/750/vector-forest-sunset-forest-sunset-forest-wallpaper-preview.jpg"
                    //       },
                    //     ).then(
                    //           (value) {
                    //         _titleController.clear();
                    //         _descriptionController.clear();
                    //         Navigator.pop(context);
                    //         ScaffoldMessenger.of(context).showSnackBar(addBlog);
                    //       },
                    //     );
                    //   }
                    // }
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