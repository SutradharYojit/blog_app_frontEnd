import 'package:flutter/material.dart';

class BloggerContactScreen extends StatelessWidget {
  const BloggerContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Screen"),
      ),
      body: const SafeArea(
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

