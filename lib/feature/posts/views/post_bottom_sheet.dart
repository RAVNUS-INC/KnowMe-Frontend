import 'package:flutter/material.dart';

class FilterDialog extends StatelessWidget {
  final String title;
  final String? selectedValue;
  final int tabIndex;

  const FilterDialog({
    Key? key,
    required this.title,
    this.selectedValue,
    required this.tabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 필터 옵션 (탭 인덱스와 필터 타이틀에 따라 결정)
    List<String> options = [];

    switch (tabIndex) {
      case 0: // 채용
        if (title == '직무') {
          options = ['개발', '마케팅', '디자인', '기획', '영업', '경영/인사', '회계/재무', '연구/설계', '기타'];
        } else if (title == '신입~5년') {
          options = ['신입', '1년 이하', '1~3년', '3~5년', '5년 이상'];
        } else if (title == '서울 전체') {
          options = ['서울 전체', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주'];
        } else if (title == '학력') {
          options = ['고졸 이상', '초대졸 이상', '대졸 이상', '석사 이상', '박사 이상', '학력 무관'];
        }
        break;

      case 1: // 인턴
        if (title == '직무') {
          options = ['개발', '마케팅', '디자인', '기획', '영업', '경영/인사', '회계/재무', '연구/설계', '기타'];
        } else if (title == '기간') {
          options = ['1개월 이하', '1~3개월', '3~6개월', '6개월 이상'];
        } else if (title == '지역') {
          options = ['서울', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주'];
        } else if (title == '학력') {
          options = ['고졸 이상', '초대졸 이상', '대졸 이상', '석사 이상', '박사 이상', '학력 무관'];
        }
        break;

      case 2: // 대외활동
        if (title == '분야') {
          options = ['IT', '디자인', '마케팅', '경영', '공학', '스타트업', '미디어', '환경', '교육', '기타'];
        } else if (title == '기관') {
          options = ['대학교', '기업', '정부기관', '비영리단체', '연구소', '기타'];
        } else if (title == '지역') {
          options = ['서울', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주', '온라인'];
        } else if (title == '주최기관') {
          options = ['기업', '정부/공공기관', '학교', '협회', '민간단체', '기타'];
        }
        break;

      case 3: // 교육/강연
        if (title == '분야') {
          options = ['IT/개발', '디자인', '마케팅', '경영', '금융', '어학', '취업준비', '자격증', '취미', '기타'];
        } else if (title == '기간') {
          options = ['1회성', '1개월 이하', '1~3개월', '3~6개월', '6개월 이상'];
        } else if (title == '지역') {
          options = ['서울', '경기', '인천', '부산', '대구', '광주', '대전', '세종', '강원', '충북', '충남', '경북', '경남', '전북', '전남', '제주'];
        } else if (title == '온/오프라인') {
          options = ['온라인', '오프라인', '혼합'];
        }
        break;

      case 4: // 공모전
      default:
        if (title == '분야') {
          options = ['IT', '디자인', '마케팅', '경영', '공학', '기타'];
        } else if (title == '대상') {
          options = ['대학생', '일반인', '청소년', '제한없음'];
        } else if (title == '주최기관') {
          options = ['기업', '정부/공공기관', '학교', '협회', '기타'];
        } else if (title == '혜택') {
          options = ['상금', '입사 가산점', '취업 연계', '해외연수', '기타'];
        }
        break;
    }

    return AlertDialog(
      title: Text('$title 선택'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final bool isSelected = option == selectedValue;

            return ListTile(
              title: Text(option),
              selected: isSelected,
              trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF0068E5)) : null,
              onTap: () {
                // 이미 선택된 옵션을 다시 클릭하면 선택 해제됨
                Navigator.of(context).pop(isSelected ? null : option);
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('취소'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
