import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginModel model = LoginModel();
    // 컨트롤러에 모델만 전달하고 텍스트 컨트롤러는 제거
    final LoginController controller = Get.put(LoginController(
      model: model,
    ));

    void dismissKeyboard() {
      FocusScope.of(context).unfocus();
    }

    return GestureDetector(
      onTap: dismissKeyboard,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Image.asset(
                    'assets/images/knowme_logo.png',
                    width: 350,
                    height: 200,
                  ),
                  const SizedBox(height: 60),
                  TextField(
                    controller: controller.idController,
                    decoration: _inputDecoration('아이디'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  Obx(() => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.obscureText.value,
                        decoration: _inputDecoration('비밀번호').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscureText.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () =>
                                controller.togglePasswordVisibility(),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => dismissKeyboard(),
                      )),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                            value: controller.rememberAccount.value,
                            onChanged: controller.toggleRememberAccount,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          )),
                      const Text('로그인 상태 저장', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => controller.handleLogin(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => controller.handleRegister(),
                        child: const Text('회원가입',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () => controller.handleForgotPassword(),
                        child: const Text('아이디/비밀번호 찾기',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _dividerWithText('또는'),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      dismissKeyboard();
                      controller.handleSocialLogin('카카오');
                    },
                    child: Image.asset(
                        'assets/images/kakao_login_medium_wide.png'),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      dismissKeyboard();
                      controller.handleSocialLogin('구글');
                    },
                    child: Image.asset('assets/images/google_login.png'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  Widget _dividerWithText(String text) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.blue.shade600)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text, style: TextStyle(color: Colors.blue.shade600)),
        ),
        Expanded(child: Container(height: 1, color: Colors.blue.shade600)),
      ],
    );
  }
}
