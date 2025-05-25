import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../controllers/search_controller.dart' as search; // Flutter 내장과 충돌 방지

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<search.SearchController>();

    return BaseScaffold(
      currentIndex: 0,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => SearchBarWithAction(
                  controller: controller.searchController,
                  isSearching: controller.isSearching.value,
                  onSearch: controller.handleSearch,
                  onCancel: () => Navigator.pop(context),
                )),
            const SizedBox(height: 20),
            _SearchHeader(onClearAll: controller.clearRecentSearches),
            const SizedBox(height: 6),
            Container(height: 1, color: const Color(0xFFE5E5E5)),
            const SizedBox(height: 8),
            // ✅ 여기서 타입도 search.SearchController로 명시
            Obx(() => Expanded(child: _buildRecentSearchList(controller))),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchList(search.SearchController controller) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 4),
      itemCount: controller.recentSearches.length,
      separatorBuilder: (_, __) =>
          Container(height: 1, color: const Color(0xFFE5E5E5)),
      itemBuilder: (context, index) {
        final item = controller.recentSearches[index];
        return RecentSearchItem(
          text: item,
          onRemove: () => controller.recentSearches.removeAt(index),
        );
      },
    );
  }
}

// ✅ 검색창과 오른쪽 '검색/취소' 버튼
class SearchBarWithAction extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final VoidCallback onSearch;
  final VoidCallback onCancel;

  const SearchBarWithAction({
    super.key,
    required this.controller,
    required this.isSearching,
    required this.onSearch,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFB7C4D4), width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/icon-search.png',
                    width: 16, height: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '검색어를 입력해 주세요',
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(top: 2),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      letterSpacing: -0.56,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 11),
        GestureDetector(
          onTap: isSearching ? onSearch : onCancel,
          child: Text(
            isSearching ? '검색' : '취소',
            style: const TextStyle(
              color: Color(0xFF72787F),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.56,
            ),
          ),
        ),
      ],
    );
  }
}

// ✅ 최근 검색어 헤더
class _SearchHeader extends StatelessWidget {
  final VoidCallback onClearAll;

  const _SearchHeader({required this.onClearAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '최근 검색어',
          style: TextStyle(
            color: Color(0xFF0068E5),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.56,
          ),
        ),
        GestureDetector(
          onTap: onClearAll,
          child: const Text(
            '전체삭제',
            style: TextStyle(
              color: Color(0xFFB7C4D4),
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
              letterSpacing: -0.40,
            ),
          ),
        ),
      ],
    );
  }
}

// ✅ 최근 검색어 아이템
class RecentSearchItem extends StatelessWidget {
  final String text;
  final VoidCallback onRemove;

  const RecentSearchItem({
    super.key,
    required this.text,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF232323),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.56,
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 16, color: Color(0xFF72787F)),
          ),
        ],
      ),
    );
  }
}
