import 'package:flutter/material.dart';

class BloggerContactScreen extends StatelessWidget {
  const BloggerContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Screen"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text("Contact Screen"),
            )
          ],
        ),
      ),
    );
  }
}

