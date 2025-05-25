import 'package:flutter/material.dart';
import 'package:knowme_frontend/shared/widgets/base_scaffold.dart'; // BaseScaffold 경로 확인해서 맞춰줘!

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // 알림 리스트 데이터
  static const List<_Notification> _notifications = [
    _Notification(
      category: '강의',
      title: '새로운 강의가 업데이트됐어요!',
      message: 'React 실전 프로젝트 강의가 추가됐어요. 지금 바로 확인해보세요!',
      date: '2025.04.16',
    ),
    _Notification(
      category: '리마인드',
      title: '관심 공고 마감 D-2',
      message: '저장한 "코드웨이브 채용" 공고 마감이 이틀 남았어요! 놓치지 마세요.',
      date: '2025.04.15',
    ),
    _Notification(
      category: '동기부여',
      title: '오늘도 한 걸음 나아가볼까요?',
      message: '어제보다 1% 더 성장하는 오늘. 포트폴리오 작성, 오늘 다시 도전해보세요!',
      date: '2025.04.11',
    ),
    _Notification(
      category: '리마인드',
      title: '이력서 제출 마감일이 다가오고 있어요',
      message: '"인사이트랩 프론트엔드 개발자" 포지션, 지원 마감일이 3일 남았습니다!',
      date: '2025.04.10',
    ),
    _Notification(
      category: '공지',
      title: '시스템 점검 안내',
      message: '4월 9일(수) 새벽 2시~4시까지 서비스 점검이 예정되어 있습니다. 이용에 참고해주세요.',
      date: '2025.04.08',
    ),
    _Notification(
      category: '리마인드',
      title: '이번 주 취업 특강, 오늘 저녁 8시',
      message: '등록하신 "리치코드 프론트엔드 부트업 세미나" 특강, 곧 시작돼요!',
      date: '2025.04.07',
    ),
    _Notification(
      category: '기능',
      title: '내 활동, AI 자동 요약으로 간편하게',
      message: 'AI 자동요약 기능으로 포트폴리오를 빠르게 정리해보세요.',
      date: '2025.04.06',
    ),
    _Notification(
      category: '공지',
      title: '프리미엄 멤버십, 연간 회원권 할인🎉',
      message: '지금 가입하면 연간 회원권 약 10% 할인 혜택!',
      date: '2025.04.05',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      activeIcon: 'bell', // 상단 오른쪽 '알림' 아이콘 강조
      showBottomBar: true,
      body: Container(
        color: Colors.grey[50],
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: _notifications.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final n = _notifications[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index < 2)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (index < 2) const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '[${n.category}]',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n.message,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          n.date,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// 알림 데이터 모델 클래스
class _Notification {
  final String category;
  final String title;
  final String message;
  final String date;

  const _Notification({
    required this.category,
    required this.title,
    required this.message,
    required this.date,
  });
}
