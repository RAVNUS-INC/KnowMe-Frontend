import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/find_id_passwd_controller.dart';

class FindIdPasswd extends StatefulWidget {
  const FindIdPasswd({super.key});

  @override
  State<FindIdPasswd> createState() => _FindIdPasswdState();
}

class _FindIdPasswdState extends State<FindIdPasswd>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FindIdPasswdController controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller = Get.put(FindIdPasswdController());

    // Add listener to update title when tab changes
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update title
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header with title and tab bar
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    // Page title from current tab
                    Center(
                      child: Text(
                        _tabController.index == 0 ? '아이디 찾기' : '비밀번호 찾기',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Close button at top right
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ),

                    // Custom tab bar
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // 아이디 찾기 탭
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _tabController.animateTo(0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      '아이디 찾기',
                                      style: TextStyle(
                                        color: _tabController.index == 0
                                            ? Colors.blue
                                            : Colors.grey,
                                        fontWeight: _tabController.index == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 3,
                                    color: _tabController.index == 0
                                        ? Colors.blue
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 비밀번호 찾기 탭
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _tabController.animateTo(1),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      '비밀번호 찾기',
                                      style: TextStyle(
                                        color: _tabController.index == 1
                                            ? Colors.blue
                                            : Colors.grey,
                                        fontWeight: _tabController.index == 1
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 3,
                                    color: _tabController.index == 1
                                        ? Colors.blue
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // 아이디 찾기 탭
                    _buildFindIdTab(),
                    // 비밀번호 찾기 탭
                    _buildFindPasswordTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 아이디 찾기 탭 내용
  Widget _buildFindIdTab() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Email radio option
          Obx(() => Row(
            children: [
              Radio<int>(
                value: 0,
                groupValue: controller.idFindMethod.value,
                onChanged: (value) {
                  controller.changeIdFindMethod(value!);
                },
                activeColor: Colors.blue,
              ),
              const Text(
                '이메일로 찾기',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )),

          // Email text field
          Obx(() => Visibility(
            visible: controller.idFindMethod.value == 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 20.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      hintText: '이메일을 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: controller.showIdFindError.value && controller.idFindMethod.value == 0 ? Colors.red : Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: controller.showIdFindError.value && controller.idFindMethod.value == 0 ? Colors.red : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: controller.showIdFindError.value && controller.idFindMethod.value == 0 ? Colors.red : Colors.blue,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  // Error message for email
                  if (controller.showIdFindError.value && controller.idFindMethod.value == 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        controller.idFindErrorMessage.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )),

          // Phone radio option
          Obx(() => Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: controller.idFindMethod.value,
                onChanged: (value) {
                  controller.changeIdFindMethod(value!);
                },
                activeColor: Colors.blue,
              ),
              const Text(
                '휴대폰 번호로 찾기',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )),

          // Phone text field
          Obx(() => Visibility(
            visible: controller.idFindMethod.value == 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 20.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller.phoneController,
                    decoration: InputDecoration(
                      hintText: '휴대폰 번호를 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: controller.showIdFindError.value && controller.idFindMethod.value == 1 ? Colors.red : Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: controller.showIdFindError.value && controller.idFindMethod.value == 1 ? Colors.red : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: controller.showIdFindError.value && controller.idFindMethod.value == 1 ? Colors.red : Colors.blue,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  // Error message for phone
                  if (controller.showIdFindError.value && controller.idFindMethod.value == 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        controller.idFindErrorMessage.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )),

          const SizedBox(height: 20),

          const Spacer(),

          // Confirm button
          Obx(() => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.canSubmitFindId.value
                  ? () => controller.submitFindId()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.canSubmitFindId.value
                    ? Colors.blue
                    : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
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
    );
  }

  // 비밀번호 찾기 탭 내용
  Widget _buildFindPasswordTab() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User ID field
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.userIdController,
                decoration: InputDecoration(
                  hintText: '아이디를 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: controller.showPasswordFindError.value ? Colors.red : Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: controller.showPasswordFindError.value ? Colors.red : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: controller.showPasswordFindError.value ? Colors.red : Colors.blue,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              // Error message for user ID
              if (controller.showPasswordFindError.value)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    controller.passwordFindErrorMessage.value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          )),

          const SizedBox(height: 20),

          const Spacer(),

          // Confirm button
          Obx(() => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.canSubmitFindPw.value
                  ? () => controller.submitFindPassword()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.canSubmitFindPw.value
                    ? Colors.blue
                    : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
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
    );
  }
}