import 'package:get/get.dart';
import '../models/profile_model.dart';
import 'package:knowme_frontend/service/user_service.dart';

class ProfileController extends GetxController {
  var userProfile = ProfileModel().obs;
  var userId = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await UserService.getCurrentUser();
      if (response.statusCode == 200) {
        final data = response.data;
        userProfile.value = ProfileModel.fromJson(data);
        userId.value = data['id'].toString();
      } else {
        errorMessage.value = '사용자 정보를 불러오는 데 실패했습니다.';
      }
    } catch (e) {
      errorMessage.value = '오류 발생: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void goToActivity() {
    Get.toNamed('/activity');
  }
}