import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/search/views/search_screen.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../controllers/search_result_controller.dart';
import '../models/contest_model.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final controller = Get.find<SearchResultController>();
  int visibleCount = 4;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 0,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWithAction(
                    controller: controller.searchController,
                    isSearching: false,
                    onSearch: () {},
                    onCancel: () => Get.back(),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '대학생 대상 공모전',
                    style: TextStyle(
                      color: Color(0xFF232323),
                      fontSize: 18,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.72,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = controller.results[index];
                  return Obx(() => _ContestCard(
                    contest: item,
                    onSave: () => controller.toggleSave(item),
                    isSaved: controller.isSaved(item),
                  ));
                },
                childCount: controller.results.length.clamp(0, visibleCount),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 180 / 240,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() {
                    visibleCount += 4;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFB7C4D4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
                      '더보기',
                      style: TextStyle(
                        color: Color(0xFFF5F5F5),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  height: 1,
                  color: const Color(0xFFE5E5E5),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 343,
                    child: Text(
                      '저장한 활동',
                      style: TextStyle(
                        color: Color(0xFF232323),
                        fontSize: 18,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.72,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = controller.savedContests[index];
                  return Obx(() => _ContestCard(
                    contest: item,
                    onSave: () => controller.toggleSave(item),
                    isSaved: controller.isSaved(item),
                  ));
                },
                childCount: controller.savedContests.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 180 / 240,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _ContestCard extends StatelessWidget {
  final Contest contest;
  final VoidCallback onSave;
  final bool isSaved;

  const _ContestCard({
    required this.contest,
    required this.onSave,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 240,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF184273).withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                contest.imageUrl,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 160,
                  color: const Color(0xFFE0E0E0),
                  alignment: Alignment.center,
                  child: const Text(
                    '이미지를 불러올 수 없음',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                right: 4,
                top: 4,
                child: GestureDetector(
                  onTap: onSave,
                  child: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contest.title,
                  style: const TextStyle(
                    color: Color(0xFF232323),
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.56,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${contest.reward}  ${contest.eligibility}',
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.48,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}