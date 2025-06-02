import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_result_controller.dart';
import '../views/search_result_screen.dart';

class SearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  RxList<String> recentSearches = <String>[].obs;
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

    Get.put(SearchResultController()).search(query);
    Get.to(() => const SearchResultScreen());

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