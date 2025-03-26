import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/blog/cubit/blog_state.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/blog/models/blog_model.dart';
import 'package:logger/logger.dart';

class BlogCubit extends Cubit<BlogState> {
  BlogCubit() : super(const BlogState.initial());

  final Logger logger = Logger();

  Future<void> loadBlogs() async {
    emit(const BlogState.loading());
    try {
      final String jsonString =
          await rootBundle.loadString('assets/blog.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      final List<BlogModel> blogs =
          jsonData.map((e) => BlogModel.fromJson(e)).toList();

      emit(BlogState.loaded(blogs: blogs));
    } catch (e) {
      logger.e('Failed to load blog data: $e');
      emit(const BlogState.error(message: 'Failed to load blog data'));
    }
  }
}
