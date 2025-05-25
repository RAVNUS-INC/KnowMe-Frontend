import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_first_controller.dart';

class SignupFirstPage extends StatefulWidget {
  const SignupFirstPage({super.key});

  @override
  State<SignupFirstPage> createState() => _SignupFirstPageState();
}

class _SignupFirstPageState extends State<SignupFirstPage> {
  // Get controller instance
  final SignupFirstController controller = Get.put(SignupFirstController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          child: const Text(
            '이전',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 페이지 인디케이터
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
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
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // 약관 동의 목록
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GetBuilder<SignupFirstController>(builder: (controller) {
                return Column(
                  children: [
                    // 전체 선택 체크박스
                    CheckboxListTile(
                      value: controller.signupModel.agreeToAllTerms,
                      onChanged: controller.updateAllTerms,
                      title: const Text(
                        '전체선택',
                        style: TextStyle(fontSize: 14),
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),

                    const Divider(),

                    // 서비스 이용약관 (필수)
                    CheckboxListTile(
                      value: controller.signupModel.agreeToServiceTerms,
                      onChanged: controller.updateServiceTerms,
                      title: Row(
                        children: [
                          const Text('(필수) 이용약관 동의',
                              style: TextStyle(fontSize: 14)),
                          const Spacer(),
                          InkWell(
                            onTap: () => controller.viewTerms('service'),
                            child: const Text(
                              '보기',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),

                    // 개인정보 수집 및 이용 동의 (필수)
                    CheckboxListTile(
                      value: controller.signupModel.agreeToPrivacyPolicy,
                      onChanged: controller.updatePrivacyPolicy,
                      title: Row(
                        children: [
                          const Text('(필수) 개인정보 수집 및 이용 동의',
                              style: TextStyle(fontSize: 14)),
                          const Spacer(),
                          InkWell(
                            onTap: () => controller.viewTerms('privacy'),
                            child: const Text(
                              '보기',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),

                    // 마케팅 정보 수신 동의 (선택)
                    CheckboxListTile(
                      value: controller.signupModel.agreeToMarketingInfo,
                      onChanged: controller.updateMarketingInfo,
                      title: Row(
                        children: [
                          const Text('(선택) 마케팅 정보 수신 동의',
                              style: TextStyle(fontSize: 14)),
                          const Spacer(),
                          InkWell(
                            onTap: () => controller.viewTerms('marketing'),
                            child: const Text(
                              '보기',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                  ],
                );
              }),
            ),
          ),

          // 다음 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: GetBuilder<SignupFirstController>(builder: (controller) {
                return ElevatedButton(
                  onPressed: controller.signupModel.isFirstNextButtonEnabled
                      ? controller.navigateToSecondPage
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.signupModel.isFirstNextButtonEnabled
                            ? Colors.blue
                            : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
