import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/resources.dart';
import '../../services/services.dart';
import '../../widget/widget.dart';
import '../view.dart';

class BloggerContactScreen extends StatelessWidget {
  BloggerContactScreen({super.key, required this.message});

  final SendBlogMes message;

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _messageCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(),
              Image.asset(
                IconAssets.appIcon,
                height: 100.h,
              ),
              Text(
                StringManager.myApp,
                style: TextStyle(
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "DancingScript",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.r),
                child: PrimaryTextFilled(
                  controller: _titleCtrl,
                  hintText: StringManager.titleHintTxt,
                  labelText: StringManager.titleLabelTxt,
                  prefixIcon: const Icon(
                    Icons.title_rounded,
                    color: ColorManager.tealColor,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.r),
                child: PrimaryTextFilled(
                  controller: _messageCtrl,
                  hintText: StringManager.messHintTxt,
                  labelText: StringManager.messLabelTxt,
                  prefixIcon: const Icon(
                    Icons.message_outlined,
                    color: ColorManager.tealColor,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              PrimaryButton(
                title: StringManager.sendMailTxt,
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(child: Loading());
                      });
                  ApiServices().postApi(
                    api: "${APIConstants.baseUrl}user/login",
                    body: {
                      "email": message.bloggerMail,
                      "bloggerName": message.bloggerName,
                      "title": _titleCtrl.text.trim(),
                      "message": _messageCtrl.text.trim()
                    },
                  ).then(
                    (value) {

                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
