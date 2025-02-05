import 'package:flutter/material.dart';
import 'http_service.dart';
import 'post_model.dart';
import 'post_detail.dart';

class PostsPage extends StatelessWidget {
  final HttpService httpService = HttpService();

  PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: FutureBuilder<List<Post>>(
        future: httpService.getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            List<Post> posts = snapshot.data!;

            if (posts.isEmpty) {
              return const Center(
                child: Text("No posts available.", style: TextStyle(fontSize: 18)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                Post post = posts[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Text("User ID: ${post.userId}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetail(post: post),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text("No data found.", style: TextStyle(fontSize: 18)),
          );
        },
      ),
    );
  }
}
