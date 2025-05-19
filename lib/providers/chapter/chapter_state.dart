import 'package:manapp/models/chapter_model.dart';

class ChapterState {
  final bool isLoading;
  final String errorMessage;
  final bool showMenu;
  final ChapterModel chapter;

  const ChapterState({
    this.isLoading = false,
    this.errorMessage = '',
    this.showMenu = false,
    this.chapter = const ChapterModel(),
  });

  ChapterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? showMenu,
    ChapterModel? chapter,
  }) {
    return ChapterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      showMenu: showMenu ?? this.showMenu,
      chapter: chapter ?? this.chapter,
    );
  }
}