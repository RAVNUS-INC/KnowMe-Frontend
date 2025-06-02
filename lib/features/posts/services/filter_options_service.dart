import 'package:get/get.dart';

/// 필터 옵션 데이터를 제공하는 서비스 클래스
class FilterOptionsService extends GetxService {
  // 옵션 리스트 반환 메서드들
  List<String> getJobOptions(int tabIndex) {
    if (tabIndex == 0 || tabIndex == 1) {
      // 채용, 인턴
      return ['개발', '마케팅', '디자인', '기획', '영업', '경영/인사', '회계/재무', '연구/설계', '기타'];
    }
    return [];
  }

  List<String> getFieldOptions(int tabIndex) {
    if (tabIndex == 2) {
      // 대외활동
      return ['IT', '디자인', '마케팅', '경영', '공학', '스타트업', '미디어', '환경', '교육', '기타'];
    } else if (tabIndex == 3) {
      // 교육/강연
      return [
        'IT/개발',
        '디자인',
        '마케팅',
        '경영',
        '금융',
        '어학',
        '취업준비',
        '자격증',
        '취미',
        '기타'
      ];
    } else if (tabIndex == 4) {
      // 공모전
      return ['IT', '디자인', '마케팅', '경영', '공학', '기타'];
    }
    return [];
  }

  List<String> getLocationOptions(int tabIndex) {
    if (tabIndex == 0) {
      // 채용
      return [
        '서울 전체',
        '경기',
        '인천',
        '부산',
        '대구',
        '광주',
        '대전',
        '세종',
        '강원',
        '충북',
        '충남',
        '경북',
        '경남',
        '전북',
        '전남',
        '제주'
      ];
    } else if (tabIndex == 1) {
      // 인턴
      return [
        '서울',
        '경기',
        '인천',
        '부산',
        '대구',
        '광주',
        '대전',
        '세종',
        '강원',
        '충북',
        '충남',
        '경북',
        '경남',
        '전북',
        '전남',
        '제주'
      ];
    } else if (tabIndex == 2) {
      // 대외활동
      return [
        '서울',
        '경기',
        '인천',
        '부산',
        '대구',
        '광주',
        '대전',
        '세종',
        '강원',
        '충북',
        '충남',
        '경북',
        '경남',
        '전북',
        '전남',
        '제주',
        '온라인'
      ];
    } else if (tabIndex == 3) {
      // 교육/강연
      return [
        '서울',
        '경기',
        '인천',
        '부산',
        '대구',
        '광주',
        '대전',
        '세종',
        '강원',
        '충북',
        '충남',
        '경북',
        '경남',
        '전북',
        '전남',
        '제주'
      ];
    }
    return [];
  }

  List<String> getOrganizerOptions(int tabIndex) {
    if (tabIndex == 2) {
      // 대외활동
      return ['기업', '정부/공공기관', '학교', '협회', '민간단체', '기타'];
    } else if (tabIndex == 4) {
      // 공모전
      return ['기업', '정부/공공기관', '학교', '협회', '기타'];
    }
    return [];
  }

  List<String> getOnOfflineOptions() {
    return ['온라인', '오프라인', '혼합'];
  }

  List<String> getTargetOptions() {
    return ['대학생', '일반인', '청소년', '제한없음'];
  }

  List<String> getBenefitOptions() {
    return ['상금', '입사 가산점', '취업 연계', '해외연수', '기타'];
  }

  List<String> getEducationOptions() {
    return ['학력 전체', '고졸', '초대졸', '대졸', '석사/박사', '학력무관'];
  }

  // 다이얼로그에 표시할 옵션 가져오기
  List<String> getOptionsForDialog(int tabIndex, String title) {
    switch (tabIndex) {
      case 0: // 채용
        if (title == '직무') {
          return getJobOptions(0);
        } else if (title == '신입~5년') {
          return ['신입', '1년 이하', '1~3년', '3~5년', '5년 이상'];
        } else if (title == '서울 전체' || title == '지역') {
          return getLocationOptions(0);
        } else if (title == '학력') {
          return getEducationOptions();
        }
        break;

      case 1: // 인턴
        if (title == '직무') {
          return getJobOptions(1);
        } else if (title == '기간') {
          return ['1개월 이하', '1~3개월', '3~6개월', '6개월 이상'];
        } else if (title == '지역') {
          return getLocationOptions(1);
        } else if (title == '학력') {
          return getEducationOptions();
        }
        break;

      case 2: // 대외활동
        if (title == '분야') {
          return getFieldOptions(2);
        } else if (title == '기관') {
          return ['대학교', '기업', '정부기관', '비영리단체', '연구소', '기타'];
        } else if (title == '지역') {
          return getLocationOptions(2);
        } else if (title == '주최기관') {
          return getOrganizerOptions(2);
        }
        break;

      case 3: // 교육/강연
        if (title == '분야') {
          return getFieldOptions(3);
        } else if (title == '기간') {
          return ['1회성', '1개월 이하', '1~3개월', '3~6개월', '6개월 이상'];
        } else if (title == '지역') {
          return getLocationOptions(3);
        } else if (title == '온/오프라인') {
          return getOnOfflineOptions();
        }
        break;

      case 4: // 공모전
      default:
        if (title == '분야') {
          return getFieldOptions(4);
        } else if (title == '대상') {
          return getTargetOptions();
        } else if (title == '주최기관') {
          return getOrganizerOptions(4);
        } else if (title == '혜택') {
          return getBenefitOptions();
        }
        break;
    }
    return [];
  }
}
