import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/base_scaffold.dart';
import '../controllers/search_result_controller.dart';
import '../models/contest_model.dart';
import 'search_screen.dart';

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWithAction(
                controller: TextEditingController(),
                isSearching: false,
                onSearch: () {},
                onCancel: () {},
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
              Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(
                  controller.results.length.clamp(0, visibleCount),
                      (index) => _ContestCard(contest: controller.results[index], onSave: () => controller.toggleSave(controller.results[index]), isSaved: controller.isSaved(controller.results[index])),
                ),
              )),
              const SizedBox(height: 16),
              Center(
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
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 1,
                color: const Color(0xFFE5E5E5),
              ),
              const SizedBox(height: 20),
              const SizedBox(
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
              const SizedBox(height: 12),
              Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controller.savedContests
                    .map((c) => _ContestCard(contest: c, onSave: () => controller.toggleSave(c), isSaved: true))
                    .toList(),
              )),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContestCard extends StatelessWidget {
  final Contest contest;
  final VoidCallback onSave;
  final bool isSaved;

  const _ContestCard({required this.contest, required this.onSave, required this.isSaved});

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
