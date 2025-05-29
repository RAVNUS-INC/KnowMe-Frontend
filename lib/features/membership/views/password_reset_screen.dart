import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/password_reset_controller.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PasswordResetController controller =
        Get.put(PasswordResetController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 상단 여백
                const SizedBox(height: 80),

                // 메인 컨테이너
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 닫기 버튼
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => Get.offAllNamed('/login'),
                            child: const Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 24,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 제목
                        const Text(
                          '비밀번호 재설정',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // 새 비밀번호 입력 필드
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '새 비밀번호',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(() => TextField(
                                  controller: controller.newPasswordController,
                                  obscureText:
                                      !controller.showNewPassword.value,
                                  decoration: InputDecoration(
                                    hintText: '새 비밀번호를 입력하세요',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
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
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.showNewPassword.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: controller
                                          .toggleNewPasswordVisibility,
                                    ),
                                  ),
                                )),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 새 비밀번호 확인 입력 필드
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '새 비밀번호 확인',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(() => TextField(
                                  controller:
                                      controller.confirmPasswordController,
                                  obscureText:
                                      !controller.showConfirmPassword.value,
                                  decoration: InputDecoration(
                                    hintText: '새 비밀번호를 다시 입력하세요',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
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
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.showConfirmPassword.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: controller
                                          .toggleConfirmPasswordVisibility,
                                    ),
                                  ),
                                )),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // 확인 버튼
                        Obx(() => SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: controller.canSubmit.value
                                    ? controller.resetPassword
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.canSubmit.value
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  '확인',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
