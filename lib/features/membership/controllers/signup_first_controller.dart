import 'package:get/get.dart';
import '../models/signup_model.dart';
import 'package:logger/logger.dart';

class SignupFirstController extends GetxController {
  final SignupModel signupModel = SignupModel();
  final logger = Logger();

  // Method to update agreement to all terms
  void updateAllTerms(bool? value) {
    signupModel.agreeToAllTerms = value ?? false;
    signupModel.agreeToServiceTerms = signupModel.agreeToAllTerms;
    signupModel.agreeToPrivacyPolicy = signupModel.agreeToAllTerms;
    signupModel.agreeToMarketingInfo = signupModel.agreeToAllTerms;
    update();
  }

  // Method to update service terms agreement
  void updateServiceTerms(bool? value) {
    signupModel.agreeToServiceTerms = value ?? false;
    _updateAllTermsStatus();
    update();
  }

  // Method to update privacy policy agreement
  void updatePrivacyPolicy(bool? value) {
    signupModel.agreeToPrivacyPolicy = value ?? false;
    _updateAllTermsStatus();
    update();
  }

  // Method to update marketing info agreement
  void updateMarketingInfo(bool? value) {
    signupModel.agreeToMarketingInfo = value ?? false;
    _updateAllTermsStatus();
    update();
  }

  // Helper method to check if all terms are agreed
  void _updateAllTermsStatus() {
    signupModel.agreeToAllTerms = signupModel.agreeToServiceTerms &&
        signupModel.agreeToPrivacyPolicy &&
        signupModel.agreeToMarketingInfo;
  }

  // Method to handle navigation to next screen
  void navigateToSecondPage() {
    if (signupModel.isFirstNextButtonEnabled) {
      Get.toNamed('/signup/second',
          arguments: {'marketingConsent': signupModel.agreeToMarketingInfo});
    }
  }

  // Method to view terms and policies
  void viewTerms(String termType) {
    switch (termType) {
      case 'service':
        logger.d('서비스 이용약관 보기');
        // Navigate to service terms page
        break;
      case 'privacy':
        logger.d('개인정보 처리방침 보기');
        // Navigate to privacy policy page
        break;
      case 'marketing':
        logger.d('마케팅 정보 수신 약관 보기');
        // Navigate to marketing terms page
        break;
    }
  }
}
