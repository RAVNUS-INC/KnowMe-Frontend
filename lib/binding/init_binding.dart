import 'package:get/get.dart';
import 'package:knowme_frontend/features/posts/controllers/filter_controller.dart';
import 'package:knowme_frontend/features/posts/controllers/post_controller.dart';
import 'package:knowme_frontend/features/posts/services/filter_options_service.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Controller 등록
    Get.put(PostController());
    Get.put(FilterController());
    
    // Services 등록
    Get.put(FilterOptionsService());

  }
}
