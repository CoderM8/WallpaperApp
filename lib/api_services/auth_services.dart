import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/modal/user_model.dart';

class ApiServices {
  static Future<Map<String, dynamic>> userLogin({required String email, required String password}) async {
    try {
      final response = await http.post(mainApi, body: {'data': '{"method_name":"user_login","package_name":"com.example.wallpapers_hd","email":"$email","password":"$password","type":"Normal"}'});
      print('LOGIN [${response.statusCode}]');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["HD_WALLPAPER"][0];
      }
      return {'error': '${response.statusCode}'};
    } catch (e) {
      print('LOGIN EXCEPTION $e');
      return {'error': e};
    }
  }

  static Future<Map<String, dynamic>> userForgotPassword({required String email}) async {
    try {
      final response = await http.post(mainApi, body: {'data': '{"method_name":"forgot_pass","package_name":"com.example.wallpapers_hd","email":"$email"}'});
      print('FORGOT [${response.statusCode}]');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["HD_WALLPAPER"][0];
      }
      return {'error': '${response.statusCode}'};
    } catch (e) {
      print('FORGOT EXCEPTION $e');
      return {'error': e};
    }
  }

  static Future<Map<String, dynamic>> userRegister({required String email, required String name, required String type, String? password, String? number, String? authId, String? image}) async {
    try {
      final response = await http.post(mainApi, body: {
        'data':
            '{"method_name":"user_register","package_name":"com.vpapps.hdwallpaper","name":"$name","email":"$email","auth_id":"$authId","type":"$type","password":"$password","phone":"$number","user_image":"$image"}'
      });
      print('REGISTER [${response.statusCode}]');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["HD_WALLPAPER"][0];
      }
      return {'error': '${response.statusCode}'};
    } catch (e) {
      print('REGISTER EXCEPTION $e');
      return {'error': e};
    }
  }

  static Future<void> getUserProfile() async {
    try {
      if (userId != null) {
        final response = await http.post(mainApi, body: {'data': '{"method_name":"user_profile","package_name":"com.vpapps.hdwallpaper","user_id":"$userId"}'});
        print('PROFILE [${response.statusCode}]');
        if (response.statusCode == 200) {
          userProfile.value = userModelFromJson(response.body).hdWallpaper;
        }
      }
    } catch (e) {
      print('PROFILE EXCEPTION $e');
    }
  }

  static Future<Map<dynamic, dynamic>> getEditProfile({required File file}) async {
    try {
      final request = http.MultipartRequest('POST', mainApi);

      request.fields['data'] =
          '{"method_name":"edit_profile","package_name":"com.vpapps.hdwallpaper","user_id":"$userId","email":"${userProfile.isNotEmpty ? userProfile[0].email : ''}","name":"${userProfile.isNotEmpty ? userProfile[0].name : ''}","phone":"${userProfile.isNotEmpty ? userProfile[0].phone : ''}"}';

      request.files.add(await http.MultipartFile.fromPath('user_image', file.path));

      http.Response response = await http.Response.fromStream(await request.send());

      print('EDIT PROFILE [${response.statusCode}]');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['HD_WALLPAPER'][0];
      }
      return {'error': '${response.statusCode}'};
    } catch (e) {
      print('EDIT PROFILE EXCEPTION $e');

      return {'error': e};
    }
  }
}
