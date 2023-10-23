import 'package:flutter/material.dart';

class BlogListingScreen extends StatelessWidget {
  const BlogListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Portfolio Screen"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text("Portfolio Screen"),
            )
          ],
        ),
      ),
    );
  }
}

