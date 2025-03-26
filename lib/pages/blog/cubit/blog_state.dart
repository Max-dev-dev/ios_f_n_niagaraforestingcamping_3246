import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/blog/models/blog_model.dart';

part 'blog_state.freezed.dart';

@freezed
abstract class BlogState with _$BlogState {
  const factory BlogState.initial() = _Initial;
  const factory BlogState.loading() = _Loading;
  const factory BlogState.loaded({required List<BlogModel> blogs}) = _Loaded;
  const factory BlogState.error({required String message}) = _Error;
}
