import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knowme_frontend/features/posts/widgets/post_list_app_bar.dart';
import 'package:knowme_frontend/features/posts/widgets/post_text_widgets.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leadingWidth: 40, // 리딩 아이콘의 너비를 줄임
        leading: Padding(
          padding: const EdgeInsets.only(left: 8), // 왼쪽 패딩 조정
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/arrow.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: EdgeInsets.zero, // 아이콘 버튼의 내부 패딩 제거
          ),
        ),
        titleSpacing: 0, // 타이틀과 리딩 아이콘 사이의 기본 간격 제거
        title: const Padding(
          padding: EdgeInsets.only(left: 8), // 로고에 약��의 패딩 추가
          child: PostListAppBar(),
        ),
        centerTitle: false, // 로고를 중앙 정렬하지 않고 왼쪽으로 정렬
      ),
      backgroundColor: Colors.white, // 배경색 추가
      body: 
      Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(),
                _buildPostContent(context),
                const SizedBox(height: 70), // 플로팅 버튼을 위한 추가 공간
              ],
            ),
          ),
          _buildFloatingActionButton(context),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Image.asset(
      'assets/posts_images/image.png',
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
    );
  }

  Widget _buildPostContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          const SizedBox(height: 4),
          const Text(
            '코드웨이브 신입 채용공고 - 프론트엔드 개발자',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20), // 피그마 상으론 32
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20), // 피그마 상으론 32

          const SectionTitle('회사 소개'),
          const SizedBox(height: 8),
          const Text(
            '코드웨이브는 웹/앱 개발, B2B SaaS 플랫폼, 데이터 기반 UI/UX 개선 등 다양한 프로젝트를 통해 빠르게 성장 중인 스타트업으로, 기술을 통해 더 나은 일상을 만드는 디지털 솔루션 기업입니다.\n\n우리는 “기술로 연결된 가치”를 믿습니다. 함께 성장하고 싶은 당��을 기다립니다.',
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/posts_images/unsplash_JdcJn85xD2k.png',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20),
          const SectionTitle('모집 부문'),
          const SizedBox(height: 8),
          const Text('프론트엔드 개발자 (신입/경력)'),

          const SizedBox(height: 24),
          const SubSectionTitle('담당 업무'),
          const SizedBox(height: 8),
          const BulletList([
            '자사 웹 서비스 및 클라이언트 프로젝트의 프론트엔드 개발',
            '디자이너 및 백엔드 개발자와의 협업을 통한 UI 구현',
            '사용자 경험 개선 및 퍼포먼스 최적화',
          ]),

          const SizedBox(height: 24),
          const SubSectionTitle('자격 요건'),
          const SizedBox(height: 8),
          const BulletList([
            'React, Vue 등 프론트엔드 프레임워크에 대한 이해',
            'HTML/CSS/JavaScript 기반 마크업 및 인터랙션 구현 가능자',
            'Git을 활용한 협업 경험',
          ]),

          const SizedBox(height: 24),
          const SubSectionTitle('우대 사항'),
          const SizedBox(height: 8),
          const BulletList([
            'TypeScript 활용 경험',
            '디자인 시스템 활용 경험',
            '개인 포트폴리오 또는 GitHub 링크 제출 가능자',
          ]),

          const SizedBox(height: 20),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20),

          const SectionTitle('근무 조건'),
          const SizedBox(height: 8),
          const BulletList([
            '고용 형태: 정규직 (수습 3개월)',
            '근무 형태: 주 2회 재택 / 자율 출퇴근제 (10~19시 코어타임)',
            '근무지: 서울 성수동 (뚝섬역 도보 5분)',
          ]),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20),

          const SectionTitle('복지'),
          const SizedBox(height: 8),
          const BulletList([
            '매달 기술도서 지원비',
            '자율과 책임 중심의 유연 근무제',
            '업무에 필요한 교육 및 컨퍼런스 지원',
            '맥북 프로 + 듀얼 모니터 기본 지급',
            '생일 반차 & 기념일 상품권 지급',
            '1년 근속 시 리프레시 휴가 5일 + 여행 지원비',
          ]),

          const SizedBox(height: 20),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20),

          const SectionTitle('전형 절차'),
          const SizedBox(height: 8),
          const Text('1. 서류 접수 → 2. 온라인 과제 → 3. 인터뷰(1회) → 4. 최종 합격'),

          const SizedBox(height: 20),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20),

          const SectionTitle('지원 방법'),
          const SizedBox(height: 8),
          const Text('이력서 및 포트���리오 제출: recruit@codewave.co.kr\n지원 마감: 2025년 5월 20일(월) 23:59까지'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 300, // 피그마: 300.dp
          height: 45, // 피그마: 45.dp
          decoration: BoxDecoration(
            color: const Color(0xFF0068E5), // 피그마: 0xFF0068E5
            borderRadius: BorderRadius.circular(8), // 피그마: 8.dp
            boxShadow: const [
              BoxShadow(
                color: Color(0x33184273), // 피그마: 0x33184273
                offset: Offset(0, 2),
                blurRadius: 4, // 피그마: 4.dp
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // 자세히 보기 버튼 동작
              },
              child: const Center(  // Center로 감싸서 텍스트 중앙 정렬
                child: Text(
                  '자세히 보기',
                  textAlign: TextAlign.center,  // 텍스트 정렬 추가
                  style: TextStyle(
                    color: Color(0xFFF5F5F5),  // 색상 코드 정확히 적용
                    fontSize: 18,
                    fontFamily: 'Pretendard',  // 폰트 패밀리 적용
                    fontWeight: FontWeight.w700,  // FontWeight 700 적용
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '코드웨이브',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Transform.translate(
          offset: const Offset(5, 0),
          child: IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
