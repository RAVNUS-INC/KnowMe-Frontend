import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxList<String> recentSearches = <String>[
    '프론트엔드 개발자',
    '프론트엔드',
    '개발자 공고',
    'HTML 강의',
    '대학생 공모전',
  ].obs;

  RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      isSearching.value = searchController.text.trim().isNotEmpty;
    });
  }

  void handleSearch() {
    final query = searchController.text.trim();
    if (query.isEmpty) return;

    recentSearches.remove(query);
    recentSearches.insert(0, query);
    searchController.clear();
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
