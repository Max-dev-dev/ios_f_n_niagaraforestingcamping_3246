import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/blog/cubit/blog_cubit.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/blog/cubit/blog_state.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/blog/models/blog_model.dart';
import 'package:share_plus/share_plus.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF152314),
      appBar: AppBar(
        toolbarHeight: 20,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF152314),
      ),
      body: BlocProvider(
        create: (context) => BlogCubit()..loadBlogs(),
        child: BlocBuilder<BlogCubit, BlogState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: state.when(
                      initial:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      loaded:
                          (blogs) => ListView.builder(
                            itemCount: blogs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == blogs.length - 1 ? 120.0 : 0,
                                ),
                                child: _buildBlogCard(context, blogs[index]),
                              );
                            },
                          ),

                      error:
                          (message) => Center(
                            child: Text(
                              message,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E1D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF101E0F), width: 4),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Text(
        'Blog',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBlogCard(BuildContext context, BlogModel blog) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogDetailScreen(blog: blog),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2E1D),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "~5 MINUTES",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 230,
              child: ElevatedButton.icon(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetailScreen(blog: blog),
                      ),
                    ),
                label: const Text(
                  "Read",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailScreen({super.key, required this.blog});

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E1D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF101E0F), width: 4),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Text(
        'Blog > Reading',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  void _shareBlog() {
    final String text =
        "${blog.title}\n\n${blog.paragraphOne}\n\n${blog.paragraphTwo}";
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF152314),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 20,
        backgroundColor: const Color(0xFF152314),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            Text(
              blog.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              blog.paragraphOne,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              blog.paragraphTwo,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 230,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    label: const Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _shareBlog,
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.share, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
