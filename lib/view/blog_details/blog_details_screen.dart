import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/resources.dart';

class BlogDetailsScreen extends StatelessWidget {
  const BlogDetailsScreen({
    super.key,
  });

  final String markdownData = """
  # Flutter Markdown Example

    This is an example of using Markdown in a Flutter app.

    ## Formatting

    - *Italic*
    - **Bold**
    - `Code`

    ## Lists

    1. First item
    2. Second item
    3. Third item

    ## Links

    [OpenAI](https://www.openai.com)

    ## Images

    ![Flutter Logo](https://flutter.dev/assets/homepage/logo/flutter-lockup-cqf-98ccdf76af1df69a4d609a73e12f44e06b874974b8eaf6fbb7e72b86553682ca0.png)
    """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog Details"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: 250.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.w),
                  ),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://c4.wallpaperflare.com/wallpaper/410/867/750/vector-forest-sunset-forest-sunset-forest-wallpaper-preview.jpg",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Title",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    Divider(
                      height: 18.h,
                      thickness: 1.5,
                      color: ColorManager.greyColor,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                    Divider(
                      height: 18.h,
                      thickness: 1.5,
                      color: ColorManager.greyColor,
                    ),
                    SizedBox(
                      height: 250,
                      child: Markdown(
                        data: """# Mastering Your Personal Finances
Personal finance is a critical aspect of our lives, impacting our financial goals, reducing stress, and securing our future. In this concise guide, we'll explore key principles for mastering your personal finances.
## **1. Create a Budget**
Start by creating a budget that outlines your income and expenses. Categorize expenses, including both fixed and variable costs. A budget empowers you to make informed financial decisions.
## **2. Build an Emergency Fund**
An emergency fund is your financial safety net. Aim to save three to six months' worth of living expenses. It provides peace of mind during unexpected financial challenges.
## **3. Manage Your Debt**
Prioritize paying down high-interest debts, like credit card balances. Strategies like the snowball or avalanche method can help you reduce debt and alleviate financial stress.
## **4. Invest for the Future**
Don't just save; invest wisely. Consider retirement accounts, diversify your investments, and be patient for long-term gains.
## **5. Set Savings Goals**
Create specific savings goals, such as a down payment for a house or a dream vacation. Goals provide motivation for consistent saving.
## **6. Continuous Financial Education**
Expand your financial knowledge through books, blogs, workshops, and webinars. Financial literacy is a powerful tool for informed decision-making.""",
                        styleSheet: MarkdownStyleSheet(
                          h1: const TextStyle(fontSize: 25),
                          h2: const TextStyle(fontSize: 20),
                          a: const TextStyle(color: Colors.blue),
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
