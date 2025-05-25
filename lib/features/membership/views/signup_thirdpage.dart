import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_third_controller.dart';
import '../models/signup_model.dart';

class SignupThirdPage extends StatefulWidget {
  const SignupThirdPage({super.key});

  @override
  State<SignupThirdPage> createState() => _SignupThirdPageState();
}

class _SignupThirdPageState extends State<SignupThirdPage> {
  // 컨트롤러 및 모델 초기화
  final SignupModel _signupModel = SignupModel();
  late SignupThirdController controller;

  // 선택 상태 변수
  String selectedDomain = SignupModel.emailDomains[0]; // '직접입력'
  String selectedGrade = SignupModel.grades[0]; // '1학년'
  String selectedPosition = SignupModel.positions[0]; // '전체'
  bool _isCurrentlyEnrolled = false;

  @override
  void initState() {
    super.initState();

    // 포커스 관련 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });

    // 컨트롤러 초기화 - TextEditingController는 컨트롤러에서 관리함
    controller = Get.put(SignupThirdController(model: _signupModel));
  }

  @override
  void dispose() {
    // 포커스 해제
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // 페이지 인디케이터
            _buildPageIndicator(),

            // 폼 필드
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GetBuilder<SignupThirdController>(
                  builder: (controller) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 이름 필드
                      _buildNameField(),
                      const SizedBox(height: 10),
                      _buildDivider(), // 구분선 추가
                      const SizedBox(height: 10),

                      // 이메일 필드
                      _buildEmailField(),
                      const SizedBox(height: 10),
                      _buildDivider(), // 구분선 추가
                      const SizedBox(height: 10),

                      // 학력 정보
                      _buildEducationFields(),
                      const SizedBox(height: 10),
                      _buildDivider(), // 구분선 추가
                      const SizedBox(height: 10),

                      // 희망직종 선택
                      _buildDesiredPositionField(),
                    ],
                  ),
                ),
              ),
            ),

            // 완료 버튼
            _buildCompleteButton(),
          ],
        ),
      ),
    );
  }

  // 앱바 위젯
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        '회원가입',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      leading: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          '이전',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 17,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.offAllNamed('/login'),
        ),
      ],
    );
  }

  // 페이지 인디케이터 위젯
  Widget _buildPageIndicator() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // 이름 입력 필드 위젯
  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: '이름 ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.nameController,
          decoration: InputDecoration(
            hintText: '이름을 입력해 주세요',
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          enableInteractiveSelection: true,
          enableSuggestions: true,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // 이메일 입력 필드 위젯
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: '이메일 ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이메일 앞부분
            Expanded(
              flex: 1,
              child: TextField(
                controller: controller.emailPrefixController,
                decoration: InputDecoration(
                  hintText: '이메일 주소',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enableInteractiveSelection: true,
                enableSuggestions: true,
              ),
            ),
            const SizedBox(width: 8),
            // @ 텍스트
            Container(
              height: 48,
              alignment: Alignment.center,
              child: const Text('@', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 8),
            // 이메일 도메인 선택 드롭다운
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50], // 배경색 변경
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedDomain,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    dropdownColor: Colors.white, // 드롭다운 메뉴 배경색
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDomain = newValue!;
                        if (selectedDomain != '직접입력') {
                          controller.updateEmailDomain(selectedDomain);
                        } else {
                          controller.updateEmailDomain(
                              controller.emailDomainController.text);
                        }
                      });
                    },
                    items: SignupModel.emailDomains
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 도메인 직접 입력 필드 (선택한 경우에만 표시)
        if (selectedDomain == '직접입력')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: controller.emailDomainController,
              decoration: InputDecoration(
                hintText: '도메인을 입력해 주세요',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[50], // 배경색 추가
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              enableInteractiveSelection: true,
              enableSuggestions: true,
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }

  // 학력 정보 입력 위젯
  Widget _buildEducationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '학력',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        // 재학 체크박스
        Row(
          children: [
            Checkbox(
              value: _isCurrentlyEnrolled,
              onChanged: (value) {
                setState(() {
                  _isCurrentlyEnrolled = value ?? false;
                  controller.updateEducationStatus(_isCurrentlyEnrolled);
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const Text('재학', style: TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        // 학교명, 학과, 학년 입력 영역
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 학교명 입력
            Expanded(
              child: TextField(
                controller: controller.schoolNameController,
                decoration: InputDecoration(
                  hintText: '학교명',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                textInputAction: TextInputAction.next,
                enableInteractiveSelection: true,
                enableSuggestions: true,
              ),
            ),
            const SizedBox(width: 8),
            // 학과 입력
            Expanded(
              child: TextField(
                controller: controller.majorController,
                decoration: InputDecoration(
                  hintText: '학과',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                textInputAction: TextInputAction.next,
                enableInteractiveSelection: true,
                enableSuggestions: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 학년 선택 드롭다운
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[50], // 배경색 변경
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedGrade,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              dropdownColor: Colors.white, // 드롭다운 메뉴 배경색
              hint: const Text('학년'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGrade = newValue!;
                  controller.updateGrade(selectedGrade);
                });
              },
              items: SignupModel.grades
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // 희망직종 선택 위젯 (바텀 시트 방식)
  Widget _buildDesiredPositionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: '희망직종 ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // 바텀 시트를 열기 위한 버튼 스타일의 컨테이너
        GestureDetector(
          onTap: () {
            // 바텀 시트 열기
            _showPositionBottomSheet(context);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedPosition == '전체' ? '희망직종 선택' : selectedPosition,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        selectedPosition == '전체' ? Colors.grey : Colors.black,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 바텀 시트를 표시하는 메서드
  void _showPositionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 스크롤 가능하도록 설정
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7, // 화면의 70%까지 확장 가능
          minChildSize: 0.5, // 최소 50%
          maxChildSize: 0.9, // 최대 90%
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // 상단 핸들 (드래그 가능한 작대기)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // 상단 헤더
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '희망직종 선택',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // 목록 (스크롤 가능)
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: SignupModel.positions.length,
                    itemBuilder: (context, index) {
                      final position = SignupModel.positions[index];
                      return ListTile(
                        title: Text(position),
                        onTap: () {
                          setState(() {
                            selectedPosition = position;
                            controller.updateDesiredPosition(position);
                          });
                          Navigator.pop(context);
                        },
                        // 현재 선택된 항목 표시
                        trailing: selectedPosition == position
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 완료 버튼 위젯
  Widget _buildCompleteButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GetBuilder<SignupThirdController>(
        builder: (controller) => SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.model.isThirdNextButtonEnabled
                ? () => controller.completeSignup()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.model.isThirdNextButtonEnabled
                  ? Colors.blue
                  : Colors.grey[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              '완료',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildDivider() {
  return Container(
    height: 1,
    color: Colors.blue,
    width: double.infinity,
  );
}
