import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../resources/resources.dart';

class TextRich extends StatelessWidget {
  const TextRich({
    super.key,
    required this.firstText,
    required this.secText,
  });

  final String firstText;
  final String secText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style:   TextStyle(color: ColorManager.tealColor, fontSize: 14.sp),
        children: <TextSpan>[
          TextSpan(
            text: '\t $secText',
            style:   TextStyle(
              color: ColorManager.blackColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          )
        ],
      ),
    );
  }
}
