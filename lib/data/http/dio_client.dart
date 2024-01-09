import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../auth_screen.dart';
import '../../main.dart';
import '../preferences.dart';
import '../service_locator.dart';
import 'urls.dart';

class DioClient {
  final String baseUrl;
  final PrettyDioLogger? loggingInterceptor;

  Dio? dio;
  String token = "";

  DioClient(this.baseUrl, Dio dioC,
      {this.loggingInterceptor, this.token = ""}) {
    //token = sl.isRegistered<LoginModel>()?sl<LoginModel>().data!.token:"";
    // print(token);
    dio = dioC;
    dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 30000
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      };
    dio!.interceptors.add(loggingInterceptor!);

    dio!.interceptors
        .add(InterceptorsWrapper(onResponse: (response, handler) async {
      if (response.statusCode != null) {
        if (response.statusCode == 401) {
          print('error ${response.statusCode}');
          unAuthorized();
        } else {
          if (response.data != null && response.data is Map) {
            if ((response.data as Map).containsKey('code')) {
              if (response.data['code'] == 401) {
                print('error ${response.data['code']}');
                unAuthorized();
              }
            }
          }
        }
      }

      return handler.next(response);
    }));
  }
  void unAuthorized() {
    if (NavigationService.navigatorKey.currentContext == null) return;
    sl<PreferenceUtils>().logout();

    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .showSnackBar(SnackBar(
      content: Text(
        'session expired, login again',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));
    Navigator.of(NavigationService.navigatorKey.currentContext!)
        .pushReplacement(MaterialPageRoute(
      builder: (context) => AuthScreen(),
    ));
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    dio!.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    dio!.options.headers['Authorization'] = 'Bearer ${Url.TOKEN}';
    dio!.options.headers['Accept-Language'] = '${Url.LOCALE}';

    print('token : ${Url.TOKEN}');

    try {
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    dio!.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    dio!.options.headers['Authorization'] = 'Bearer ${Url.TOKEN}';
    dio!.options.headers['Accept-Language'] = '${Url.LOCALE}';

    try {
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    dio!.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    dio!.options.headers['Authorization'] = 'Bearer ${Url.TOKEN}';
    dio!.options.headers['Accept-Language'] = '${Url.LOCALE}';

    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }
}
