import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/post_detail_controller.dart';
import 'package:knowme_frontend/features/posts/widgets/post_text_widgets.dart';
import 'package:knowme_frontend/shared/widgets/base_scaffold.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 컨트롤러 인스턴스 가져오기 (바인딩에서 주입됨)
    final controller = Get.find<PostDetailController>();

    return BaseScaffold(
      currentIndex: 0, // 공고 탭 활성화
      showBackButton: true, // 뒤로가기 버튼 표시
      onBack: () => Navigator.of(context).pop(), // 뒤로가기 동작
      backgroundColor: const Color(0xFFF5F5F5), // 배경색 변경
      body: Obx(() {
        // 로딩 상태
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 에러 상태
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        }

        // 데이터가 없는 경우
        final postDetail = controller.postDetail.value;
        if (postDetail == null) {
          return const Center(
            child: Text('공고 정보를 찾을 수 없습니다.'),
          );
        }

        // 정상 상태 - 상세 화면 표시
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderImage(postDetail),
                  _buildPostContent(context, postDetail, controller),
                  const SizedBox(height: 70), // 플로팅 버튼을 위한 추가 공간
                ],
              ),
            ),
            _buildFloatingActionButton(context, controller),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderImage(dynamic postDetail) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _getImageProvider(postDetail.validImageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// 이미지 프로바이더 결정
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    } else if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('assets/images/whitepage.svg');
    }
  }

  Widget _buildPostContent(BuildContext context, dynamic postDetail, PostDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(postDetail, controller),
          const SizedBox(height: 4),
          Text(
            postDetail.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // 카테고리와 기본 정보 표시
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${controller.getCategoryDisplayName()} • ${postDetail.primaryInfo}',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20),

          // 회사/기관 소개
          if (postDetail.companyIntro.isNotEmpty) ...[
            const SectionTitle('회사 소개'),
            const SizedBox(height: 8),
            Text(postDetail.companyIntro),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
          ],

          // ✅ 새로 추가: 대외활동 정보 종합 섹션
          if (controller.getCategoryDisplayName() == '대외활동') ...[
            _buildExternalActivityInfoSection(postDetail),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
          ],

          // 대외활동 정보
          if (postDetail.parsedContent?.externalInfo?.isNotEmpty == true) ...[
            const SectionTitle('활동 소개'),
            const SizedBox(height: 8),
            _buildBulletText(postDetail.parsedContent!.externalInfo!),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
          ],

          // 대외활동 시간 및 장소
          if (postDetail.parsedContent?.externalTimeAndLocation?.isNotEmpty == true) ...[
            const SectionTitle('시간 및 장소'),
            const SizedBox(height: 8),
            _buildBulletText(postDetail.parsedContent!.externalTimeAndLocation!),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
          ],

          // 대외활동 프로세스
          if (postDetail.parsedContent?.externalProcess?.isNotEmpty == true) ...[
            const SectionTitle('진행 과정'),
            const SizedBox(height: 8),
            _buildBulletText(postDetail.parsedContent!.externalProcess!),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
          ],

          // 모집 부문 (구조화된 정보)
          if (postDetail.parsedContent?.recruitmentPart?.isNotEmpty == true) ...[
            _buildRecruitmentSection(postDetail.parsedContent!.recruitmentPart!),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
          ],

          // 근무 조건
          if (postDetail.parsedContent?.workConditions != null) ...[
            _buildWorkConditionsSection(postDetail.parsedContent!.workConditions!),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
          ],

          // 복지
          if (postDetail.parsedContent?.benefits?.isNotEmpty == true) ...[
            _buildBenefitsSection(postDetail.parsedContent!.benefits!),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
          ],

          // 전형 절차
          if (postDetail.parsedContent?.recruitmentProcess?.isNotEmpty == true) ...[
            _buildRecruitmentProcessSection(postDetail.parsedContent!.recruitmentProcess!),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),
          ],

          // 지원 방법
          if (postDetail.parsedContent?.applicationMethod?.isNotEmpty == true) ...[
            _buildApplicationMethodSection(postDetail.parsedContent!.applicationMethod!),
            const SizedBox(height: 20),
          ],

          // 기본 정보는 항상 표시
          const SectionTitle('기본 정보'),
          const SizedBox(height: 8),
          _buildInfoSection(postDetail),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// ✅ 새로 추가: 대외활동 정보 섹션
  Widget _buildExternalActivityInfoSection(dynamic postDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // 주최기관
        if (postDetail.hostingOrganization.isNotEmpty) ...[
          const SubSectionTitle('주최기관'),
          const SizedBox(height: 6),
          Text(postDetail.hostingOrganization),
          const SizedBox(height: 16),
        ],

        // 대상
        if (postDetail.targetAudience.isNotEmpty) ...[
          const SubSectionTitle('참가 대상'),
          const SizedBox(height: 6),
          _buildBulletText(postDetail.targetAudience),
          const SizedBox(height: 16),
        ],

        // 활동 분야
        if (postDetail.activityField.isNotEmpty) ...[
          const SubSectionTitle('활동 분야'),
          const SizedBox(height: 6),
          Text(postDetail.activityField),
          const SizedBox(height: 16),
        ],


        // 진행방식
        if (postDetail.onlineOrOffline.isNotEmpty) ...[
          const SubSectionTitle('진행 방식'),
          const SizedBox(height: 6),
          Text(postDetail.onlineOrOffline),
        ],
      ],
    );
  }

  /// 모집 부문 섹션 (List로 변경)
  Widget _buildRecruitmentSection(List<dynamic> recruitmentParts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('모집 부문'),
        const SizedBox(height: 8),

        // 여러 모집 부문이 있을 수 있으므로 반복 처리
        ...recruitmentParts.map((part) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (part.role?.isNotEmpty == true) ...[
                Text(
                  part.role!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],

              if (part.jobResponsibilities?.isNotEmpty == true) ...[
                const SubSectionTitle('담당 업무'),
                const SizedBox(height: 8),
                _buildBulletText(part.jobResponsibilities!),
                const SizedBox(height: 16),
              ],

              if (part.qualifications?.isNotEmpty == true) ...[
                const SubSectionTitle('자격 요건'),
                const SizedBox(height: 8),
                _buildBulletText(part.qualifications!),
                const SizedBox(height: 16),
              ],

              if (part.preferredSkills?.isNotEmpty == true) ...[
                const SubSectionTitle('우대 사항'),
                const SizedBox(height: 8),
                _buildBulletText(part.preferredSkills!),
                const SizedBox(height: 16),
              ],
            ],
          );
        }).toList(),
      ],
    );
  }

  /// 근무 조건 섹션 (서버 응답에 맞춰 수정)
  Widget _buildWorkConditionsSection(dynamic workConditions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('근무 조건'),
        const SizedBox(height: 8),

        if (workConditions.employmentType?.isNotEmpty == true)
          Text('• 고용 형태: ${workConditions.employmentType}'),
        if (workConditions.workType?.isNotEmpty == true)
          Text('• 근무 형태: ${workConditions.workType}'),
        if (workConditions.location?.isNotEmpty == true)
          Text('• 근무지: ${workConditions.location}'),
      ],
    );
  }

  /// 복지 섹션 (String으로 수정)
  Widget _buildBenefitsSection(String benefits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('복지'),
        const SizedBox(height: 8),
        _buildBulletText(benefits),
      ],
    );
  }

  /// 전형 절차 섹션 (String으로 수정)
  Widget _buildRecruitmentProcessSection(String recruitmentProcess) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('전형 절차'),
        const SizedBox(height: 8),
        Text(recruitmentProcess),
      ],
    );
  }

  /// 지원 방법 섹션 (String으로 수정)
  Widget _buildApplicationMethodSection(String applicationMethod) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('지원 방법'),
        const SizedBox(height: 8),
        _buildBulletText(applicationMethod),
      ],
    );
  }

  /// 개행 문자를 기준으로 불릿 리스트 생성
  Widget _buildBulletText(String text) {
    final lines = text.split('\n').where((line) => line.trim().isNotEmpty).toList();

    if (lines.length == 1) {
      return Text(text);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(height: 1.5)),
            Expanded(
              child: Text(
                line.trim(),
                style: const TextStyle(height: 1.5),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildInfoSection(dynamic postDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (postDetail.location.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• 지역: ${postDetail.location}'),
          ),
        if (postDetail.jobTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• 직무/분야: ${postDetail.jobTitle}'),
          ),
        if (postDetail.formattedExperience.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• 경력: ${postDetail.formattedExperience}'),
          ),
        if (postDetail.formattedActivityDuration.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• 기간: ${postDetail.formattedActivityDuration}'),
          ),
        if (postDetail.hostingOrganization.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• 주최기관: ${postDetail.hostingOrganization}'),
          ),
        if (postDetail.onlineOrOffline.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• 진행방식: ${postDetail.onlineOrOffline}'),
          ),
        // ✅ 새로 추가: 대상 정보
        if (postDetail.targetAudience.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('• 참가대상: ${postDetail.targetAudience.split('\n').first}'),
          ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, PostDetailController controller) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 300,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF0068E5),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33184273),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: controller.navigateToExternalLink,
              child: const Center(
                child: Text(
                  '자세히 보기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF5F5F5),
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(dynamic postDetail, PostDetailController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            postDetail.company.isNotEmpty ? postDetail.company : postDetail.hostingOrganization,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Transform.translate(
          offset: const Offset(5, 0),
          child: Obx(() => IconButton(
            icon: Icon(
              controller.isBookmarked.value
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: controller.isBookmarked.value
                  ? Colors.blue
                  : Colors.grey,
            ),
            onPressed: controller.toggleBookmark,
          )),
        ),
      ],
    );
  }
}
