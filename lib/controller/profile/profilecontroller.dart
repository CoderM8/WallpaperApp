import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallpapers_hd/api_services/auth_services.dart';
import 'package:wallpapers_hd/constant.dart';

class ProfileController extends GetxController {
  RxBool isUpload = false.obs;
  File? selectImage;

  Future<File?> pickedImage() async {
    isUpload.value = false;
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      selectImage = File(file.path);
      Map update = await ApiServices.getEditProfile(file: File(file.path));
      if (update.isNotEmpty) {
        if (update['success'] == '1') {
          await ApiServices.getUserProfile();
          showToast(message: update['MSG']);
          isUpload.value = true;
        } else {
          showToast(message: update['MSG']);
        }
      } else {
        showToast(message: 'Api Exception');
      }
    }
    return null;
  }
}
