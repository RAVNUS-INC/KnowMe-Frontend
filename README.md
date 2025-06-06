# knowme_frontend
<p align="center">
<img width="300" alt="knowme_logo" src="https://github.com/user-attachments/assets/dced07f3-4885-4d9c-acdb-951fff928fb3" />


## 🖥️ 프로젝트 소개
Know Me는 사용자의 활동을 편리하게 기록할 수 있게 제공하고 AI를 이용하여 진로 · 채용 맞춤 솔루션을 제공하는 경력 관리 플랫폼입니다.

본 프론트엔드 프로젝트는 Flutter 기반으로 개발되었으며, Android Studio와 GitHub를 활용해 팀원들과 효율적으로 협업했습니다.


## 📖 개발 기간
2025년 5월 ~ 2025년 6월 (약 2개월)
> 5월 - 플러터 이용 UI 화면 구현

> 6월 - API 연동


## 👤 멤버구성
### 1. 황유림 (프론트엔드 팀장)
- 주요 담당
  + 공고 및 활동 추천 기능
- 관련 기능
  + 게시물(채용, 인턴, 공모전 등) 및 추천 기능

### 2. 여인범
- 주요 담당
  + 회원 가입 및 내 정보 수정
- 관련 기능
  + 회원 관련 기능 전체

### 3. 장지민
- 주요 담당
  + 홈 화면, 검색, AI분석 및 요약 기능
- 관련 기능
  + 메인 홈, 알림, 검색, AI 분석

### 4. 윤서현
- 주요 담당
  + 내 활동 관리 및 알림 기능
- 관련 기능
  + 활동 아카이빙, 알림
 
### 5. 이동원 (프로젝트 팀장)
- 주요 담당
  + 프로젝트 총괄
  + 프로젝트 디테일 관리 
  + 코드 리뷰 및 피드백
  + API 연동
  + SPLASH Screen
  + App ICON

### 6. 장성윤 (대표 리뷰어)
- 주요 담당
  + 프로젝트 디테일 관리
  + 코드 리뷰 및 피드백
  + 서버 구축


## ⚙️ 개발 환경
`Flutter SDK`
`Dart >=3.4.1 <4.0.0`
- **_Development Environment_** : <img alt="Android Studio" src ="https://img.shields.io/badge/AndroidStudio-007396.svg?&style=for-the-badge&logo=ANdroidStudio&logoColor=white"/>

- **_Library_** : <img alt="GetX" src ="https://img.shields.io/badge/GetX-007396.svg?&style=for-the-badge&logo=GetX&logoColor=purple"/>

- **_Version Management_** : <img alt="Git" src ="https://img.shields.io/badge/Git-007396.svg?&style=for-the-badge&logo=Git&logoColor=orange"/> <img alt="GitHub" src ="https://img.shields.io/badge/GitHub-007396.svg?&style=for-the-badge&logo=GitHub&logoColor=black"/>

## 🔧 주요 기능
### 회원가입 및 로그인
<p align="center">
<img width="300" src="https://github.com/user-attachments/assets/c6d7ce0a-d90f-43da-8e62-d4adce49df1d" />

- 아이디/ 비밀번호를 이용한 일반 로그인 및 회원가입 지원
- 네이버, 구글 등의 간편 로그인 및 회원가입 기능 포함

### 공고 및 활동 추천
<p align="center">
  <img width="300" src="https://github.com/user-attachments/assets/61fc489d-0b48-4a36-9db1-269d85e9cc6a" />

- 다양한 채용 공고와 인턴십, 대외활동, 공모전 등을 카드 형태로 한눈에 확인
- 사용자의 활동 정보와 맞춤형 추천 알고리즘을 통해 개인에게 적합한 대외활동 및 채용 공고를 제공
- 추천 활동 및 저장한 활동을 탭으로 구분하여 접근의 용이성 강조
- 스와이프 가능한 카드 UI 및 깔끔한 리스트 구성

### 내 활동 분석/ AI 분석
<p align="center">
<img width="300" src="https://github.com/user-attachments/assets/60d082b4-017c-4af8-ae19-7bd7136edcb8" />
<img width="300" src="https://github.com/user-attachments/assets/8ab62e3e-41f3-4543-a01c-3c4edccf11e6" />

- 내 활동 내용 기반 AI의 분석 제공
- 다양한 관점에서의 내 역량 요약 기능
- 활동 추천으로 자연스럽게 연결되어 사용자 경험을 강화


## 📂 프로젝트 구조
```shell
lib/
├── core/

│   ├── constants/       # API 기본 URL·엔드포인트

│   ├── utils/           # 공통 유틸 함수

│   └── theme/           # 색상·폰트·테마 정의

├── shared/

│   ├── services/        # RestClient 등 HTTP 클라이언트 래퍼

│   │   └── api_client.dart # 공통 API 호출 클라이언트로 일원화

│   │   └── user_api_service.dart # 도메인별 엔드포인트 집합

│   │   └── contest_api_service.dart

│   │

│   ├── repositories/    # 여러 기능에서 재사용되는 Repository

│   │   └── user_repository.dart

│   │

│   └── widgets/         # 공통 위젯 (로딩·버튼 등)

├── feature/ 

│   ├── membership/      # 회원 관련

│   │   ├── models/      # UserDto, Session 등

│   │   ├── repositories/# AuthRepository (Shared/ApiClient 사용)

│   │   │   └── auth_repository.dart

│   │   ├── controllers/ # MembershipController (GetxController)

│   │   └── views/       # LoginScreen·SignupScreen 등

│   │

│   ├── posts/           # 게시물 (채용·인턴·공모전)

│   │   ├── models/      # Post, PagingInfo

│   │   ├── repositories/# PostsRepository

│   │   ├── controllers/ # PostsController

│   │   └── views/       # PostListScreen·PostDetailScreen

│   │

│   ├── activity/        # 내 활동

│   │   ├── models/      # ActivityRecord

│   │   ├── repositories/# ActivityRepository

│   │   ├── controllers/ # ActivityController

│   │   └── views/       # ActivityScreen·ActivityForm

│   │

│   ├── recommendation/  # 활동 추천

│   │   ├── models/      # RecommendationItem

│   │   ├── repositories/# RecommendationRepository

│   │   ├── controllers/ # RecommendationController

│   │   └── views/       # RecommendationScreen

│   │

│   ├── ai_analysis/     # AI 분석

│   │   ├── models/      # AnalysisResult

│   │   ├── repositories/# AiRepository

│   │   ├── controllers/ # AiController

│   │   └── views/       # AiAnalysisScreen

│   │

│   ├── search/          # 검색

│   │   ├── models/      # SearchResult

│   │   ├── repositories/# SearchRepository

│   │   ├── controllers/ # SearchController

│   │   └── views/       # SearchScreen·SearchWidget

│   │

│   └── home/            # 홈·알림

│       ├── models/      # NotificationItem

│       ├── repositories/# NotificationRepository

│       ├── controllers/ # HomeController

│       └── views/       # HomeScreen·NotificationWidget

└── routes/              # AppRoutes·RouteGenerator
