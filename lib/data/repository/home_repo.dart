import 'package:dio/dio.dart';
import 'package:translatorclient/data/http/dio_client.dart';
import 'package:translatorclient/data/http/urls.dart';
import 'package:translatorclient/model/categories_model.dart';
import 'package:translatorclient/model/languages_response.dart';
import 'package:translatorclient/model/sliders_response.dart';

import '../service_locator.dart';

class HomeRepository {
  Future getLanguages() async {
    try {
      Response response = await sl<DioClient>().get(
        Url.LANGUAGES_URL,
      );

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        List<Language> languages =
            (parsedJson as List).map((i) => Language.fromJson(i)).toList();
        return {'message': '', 'data': languages};
      }

      return {'message': parsedJson['message'], 'data': []};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': []};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': []};
      }
    }
  }

  Future getSliders() async {
    try {
      Response response = await sl<DioClient>().get(
        Url.SLIDERS_URL,
      );

      final parsedJson = response.data;
      if (response.statusCode! < 400 && parsedJson['code'] == 200) {
        SlidersResponse slidersResponse = SlidersResponse.fromJson(parsedJson);
        return {'message': '', 'data': slidersResponse.data};
      }

      return {
        'message': parsedJson['message'],
        'data': ['']
      };
    } catch (e) {
      if (e is DioError) {
        return {
          'message': e.message,
          'data': ['']
        };
        //return {'message':e.message};
      } else {
        return {
          'message': 'unknown error',
          'data': ['']
        };
      }
    }
  }

  Future getMainBrands({String? search = ' '}) async {
    try {
      String url = '${Url.MAIN_CATEGORIES_URL}${search}';
      if (search == ' ') url = Url.BRANDS;
      Response response = await sl<DioClient>().get(url);

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        CategoriesModel categoriesModel = CategoriesModel.fromJson(parsedJson);
        return {
          'message': 'Done',
          'data': categoriesModel.data
                  ?.where((element) => element.status == 'approved')
                  .toList() ??
              []
        };
      }

      return {'message': parsedJson['message'], 'data': []};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': []};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': []};
      }
    }
  }

  Future getExclusiveCategories({String? search}) async {
    try {
      Response response = await sl<DioClient>().get(
        Url.EXCLUSIVE_CATEGORIES_URL,
      );

      final parsedJson = response.data;
      if (parsedJson['code'] == 200) {
        CategoriesModel categoriesModel = CategoriesModel.fromJson(parsedJson);
        return {
          'message': categoriesModel.message,
          'data': categoriesModel.data
        };
      }

      return {'message': parsedJson['message'], 'data': []};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': []};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': []};
      }
    }
  }

  Future getSubCategories(String id) async {
    try {
      Response response = await sl<DioClient>().get(
        '${Url.SUB_CATEGORIES_URL}/$id',
      );

      final parsedJson = response.data;
      if (parsedJson['code'] == 200) {
        CategoriesModel categoriesModel = CategoriesModel.fromJson(parsedJson);
        return {
          'message': categoriesModel.message,
          'data': categoriesModel.data
        };
      }

      return {'message': parsedJson['message'], 'data': []};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': []};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': []};
      }
    }
  }
}
