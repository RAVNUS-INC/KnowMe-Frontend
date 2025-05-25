import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_second_controller.dart';

class SignupSecondPage extends StatelessWidget {
  const SignupSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SignupSecondController());
    // GetX 컨트롤러 초기화

    return GestureDetector(
      onTap: () {
        // 키보드 숨기기
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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

            // 폼 필드
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 아이디 입력 필드
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '아이디 ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<SignupSecondController>(
                      builder: (controller) => TextField(
                        controller: controller.idController,
                        decoration: InputDecoration(
                          hintText: '아이디를 입력해 주세요',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          suffixIcon: controller.signupModel.isIdValid
                              ? const Icon(Icons.check_circle,
                                  color: Colors.blue)
                              : null,
                        ),
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '아이디는 6자 이상, 영문, 숫자를 각각 1자 이상 포함해야 합니다',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 비밀번호 입력 필드
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '비밀번호 ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<SignupSecondController>(
                      builder: (controller) => TextField(
                        controller: controller.passwordController,
                        obscureText: !controller.signupModel.obscurePassword,
                        decoration: InputDecoration(
                          hintText: '비밀번호를 입력해 주세요',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (controller.signupModel.isPasswordValid)
                                const Icon(Icons.check_circle,
                                    color: Colors.blue),
                              IconButton(
                                icon: Icon(
                                  controller.signupModel.obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '영문, 숫자를 포함한 8자 이상이어야 합니다',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 비밀번호 확인 입력 필드
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '비밀번호 확인 ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<SignupSecondController>(
                      builder: (controller) => TextField(
                        controller: controller.passwordConfirmController,
                        obscureText:
                            !controller.signupModel.obscurePasswordConfirm,
                        decoration: InputDecoration(
                          hintText: '비밀번호를 입력해 주세요',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (controller.signupModel.isPasswordConfirmValid)
                                const Icon(Icons.check_circle,
                                    color: Colors.blue),
                              IconButton(
                                icon: Icon(
                                  controller.signupModel.obscurePasswordConfirm
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed:
                                    controller.togglePasswordConfirmVisibility,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 휴대폰 번호 입력 필드
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '휴대폰 번호 ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<SignupSecondController>(
                      builder: (controller) => Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.phoneController,
                              decoration: InputDecoration(
                                hintText: '휴대폰번호를 입력해 주세요',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: controller.signupModel.isPhoneValid
                                  ? controller.sendVerificationCode
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                '인증번호',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 인증번호 입력 필드
                    GetBuilder<SignupSecondController>(
                      builder: (controller) => TextField(
                        controller: controller.verificationCodeController,
                        decoration: InputDecoration(
                          hintText: '인증번호를 입력해 주세요',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 다음 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GetBuilder<SignupSecondController>(
                builder: (controller) => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.signupModel.isSecondNextButtonEnabled
                        ? controller.navigateToThirdPage
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.signupModel.isSecondNextButtonEnabled
                              ? Colors.blue
                              : Colors.grey[400],
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
