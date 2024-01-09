import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:translatorclient/data/http/dio_client.dart';
import 'package:translatorclient/data/http/urls.dart';
import 'package:translatorclient/data/preferences.dart';
import 'package:translatorclient/model/my_documents_response.dart';

import '../../model/auth_response.dart';
import '../../model/notifications_model.dart';
import '../service_locator.dart';

class AuthRepository {
  Future login(String phone, String password, String type) async {
    Map<String, String> body = {
      'phone': phone,
      'password': password,
      'type': type,
      'email': phone
    };
    try {
      Response response =
          await sl<DioClient>().post(Url.LOGIN_URL, data: jsonEncode(body));

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        AuthResponse loginModel = AuthResponse.fromJson(parsedJson);
        return {'message': 'Welcome', 'data': loginModel};
      }

      return {'message': 'Not found'};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error'};
      }
    }
  }

  Future register(Map<String, String> body) async {
    try {
      Response response =
          await sl<DioClient>().post(Url.REGISTER_URL, data: jsonEncode(body));

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        //UserModel loginModel = UserModel.fromJson(parsedJson);
        return {'message': 'Done', 'data': true};
      }

      return {'message': 'Error', 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future updateProfile(Map<String, String> body) async {
    try {
      Response response = await sl<DioClient>()
          .post(Url.UPDATE_PROFILE_URL, data: jsonEncode(body));

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        AuthResponse loginModel = AuthResponse.fromJson(parsedJson);
        sl<PreferenceUtils>().saveUser(loginModel..updateToken(Url.TOKEN));
        print('user is ${sl<AuthResponse>().user!.name}');
        return {'message': 'Done', 'data': true};
      }

      return {'message': 'Error', 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future deleteAccount(int id) async {
    try {
      Response response =
          await sl<DioClient>().delete('${Url.DELETE_USER_URL}/${id}');

      return {'message': '', 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future updateUserAvatar(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Response response =
          await sl<DioClient>().post(Url.UPDATE_AVATAR_URL, data: formData);

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        AuthResponse loginModel = AuthResponse.fromJson(parsedJson);
        sl<PreferenceUtils>().saveUser(loginModel..updateToken(Url.TOKEN));
        print('user is ${sl<AuthResponse>().user!.name}');
        return {'message': parsedJson['message'], 'data': true};
      }

      return {'message': parsedJson['message'], 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future addBrand(File file, Map<String, dynamic> params) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "brand_logo":
            await MultipartFile.fromFile(file.path, filename: fileName),
      }..addAll(params));

      print('request ${params.toString()}');

      Response response =
          await sl<DioClient>().post(Url.BRANDS, data: formData);

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        return {'message': 'Done, waiting for approve...', 'data': true};
      }

      return {'message': 'Server error', 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future addProducts(File file, Map<String, dynamic> params) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "product_image":
            await MultipartFile.fromFile(file.path, filename: fileName),
      }..addAll(params));

      print('request ${params.toString()}');

      Response response =
          await sl<DioClient>().post(Url.PRODUCTS, data: formData);

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        return {'message': 'Done, waiting for approve...', 'data': true};
      }

      return {'message': 'Server error', 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future getProfile() async {
    try {
      Response response = await sl<DioClient>().post(
        Url.PROFILE_URL,
      );

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        AuthResponse loginModel = AuthResponse.fromJson(parsedJson);
        sl<PreferenceUtils>().saveUser(loginModel..updateToken(Url.TOKEN));
        return {'message': 'Done', 'data': true};
      }

      return {'message': 'Error', 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future getTerms() async {
    try {
      Response response = await sl<DioClient>().get(
        Url.CONDITIONS_URL,
      );

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        return {'message': '', 'data': parsedJson['data']['client_conditions']};
      }

      return {'message': 'Error', 'data': ''};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': ''};
      } else {
        return {'message': 'unknown error', 'data': ''};
      }
    }
  }

  Future getMyDocuments() async {
    try {
      Response response = await sl<DioClient>().get(
        Url.MY_DOCUMENTS_URL,
      );

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        return {
          'message': parsedJson['message'],
          'data': MyDocumentsResponse.fromJson(parsedJson).data!.myFiles
        };
      }

      return {'message': parsedJson['message'], 'data': [] as List<MyFiles>};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': [] as List<MyFiles>};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': [] as List<MyFiles>};
      }
    }
  }

  Future getNotifications(int page) async {
    Map<String, dynamic> query = {'page': page};
    try {
      Response response = await sl<DioClient>()
          .get(Url.NOTIFICATIONS_URL, queryParameters: query);

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        return {
          'message': parsedJson['message'],
          'data': NotificationsModel.fromJson(parsedJson).data!.data,
          'total': NotificationsModel.fromJson(parsedJson).data!.total ?? 0
        };
      }

      return {'message': parsedJson['message'], 'data': [], 'total': 0};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': [], 'total': 0};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': [], 'total': 0};
      }
    }
  }

  Future subscribeNotifications(String token) async {
    Map<String, dynamic> body = {'device_key': token};
    try {
      Response response = await sl<DioClient>()
          .get(Url.SUBSCRIBE_NOTIFICATIONS_URL, queryParameters: body);

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        return {'message': parsedJson['message'], 'data': true};
      }

      return {'message': parsedJson['message'], 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future<Map> forgotPassword(String phone) async {
    Map<String, String> body = {
      'phone': phone,
    };
    try {
      Response response = await sl<DioClient>()
          .post(Url.FORGOT_PASSWORD, data: jsonEncode(body));

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        return {'message': parsedJson['message'], 'data': true};
      }

      return {'message': parsedJson['message'], 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future<Map> verify(String phone, String code) async {
    Map<String, String> body = {
      'phone': phone,
      'token': code,
    };
    try {
      Response response =
          await sl<DioClient>().post(Url.VERIFY_PHONE, data: jsonEncode(body));

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        return {'message': parsedJson['message'], 'data': true};
      }

      return {'message': parsedJson['message'], 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }

  Future<Map> resetPassword(String phone, String code, String password) async {
    Map<String, String> body = {
      'phone': phone,
      'token': code,
      'password': password,
      'password_confirmation': password,
    };
    try {
      Response response = await sl<DioClient>()
          .post(Url.RESET_PASSWORD, data: jsonEncode(body));

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        return {'message': parsedJson['message'], 'data': true};
      }

      return {'message': parsedJson['message'], 'data': false};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': false};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': false};
      }
    }
  }
}
