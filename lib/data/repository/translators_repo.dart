import 'package:dio/dio.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as of;
import 'package:translatorclient/data/http/dio_client.dart';
import 'package:translatorclient/data/http/urls.dart';
import 'package:translatorclient/model/categories_model.dart';
import 'package:translatorclient/model/global_products.dart';
import 'package:translatorclient/model/translators_model.dart';

import '../service_locator.dart';

class TranslatorsRepository {
  Future getBrandProducts(int? id, int page,
      {Map<String, dynamic>? filter, String? search = ' '}) async {
    try {
      if (filter == null) {
        filter = {'page': page.toString()};
      } else {
        filter.putIfAbsent('page', () => page.toString());
      }

      String url = '${Url.CATEGORY_TRANSLATOR_URL}${search}';
      if (search == ' ') url = Url.PRODUCTS;
      Response response = await sl<DioClient>().get(url);

      final parsedJson = response.data;
      if (response.statusCode! < 400) {
        TranslatorsModel translatorsModel =
            TranslatorsModel.fromJson(parsedJson);
        return {
          'message': 'success',
          'data': translatorsModel.translators
                  ?.where((element) => element.status == 'approved')
                  .toList() ??
              []
        };
      }

      return {'message': 'no data found', 'data': []};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': []};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': []};
      }
    }
  }

  Future getGlobalProducts({String? search}) async {
    List<Product> globalArray = [];
    List<String> countriesSupportingIsrael = [
      'United States',
      'Canada',
      'United Kingdom',
      'Germany',
      'France',
      'Australia',
      'India',
      'Italy',
      'Netherlands',
      'Greece',
      'Czech Republic',
      'Hungary',
      'Romania',
      'Bulgaria',
      'Austria',
    ];

    try {
      Response? response2;
      if (search != ' ') {
        response2 = await Dio().get(
            'https://world.openfoodfacts.org/api/v2/search?code=${search}&fields=code,product_name,brands,countries,image_url');
      }
      GlobalResponse? globalResponse;
      try {
        if (response2 != null) {
          globalResponse = GlobalResponse.fromJson(response2.data);
          globalArray = globalResponse.products!.map((e) {
            int isAlternative = 1;
            countriesSupportingIsrael.forEach((element) {
              if (e.countries!.toLowerCase().contains(element.toLowerCase()))
                isAlternative = 0;
            });

            return Product(
                name: e.productName,
                details: e.brands,
                image: e.imageUrl,
                isAlternative: isAlternative);
          }).toList();

          print(response2.data.toString());
        }
      } catch (e) {
        globalArray = [];
      }

      return {'message': 'success', 'data': globalArray};
    } catch (e) {
      if (e is DioError) {
        return {'message': e.message, 'data': []};
        //return {'message':e.message};
      } else {
        return {'message': 'unknown error', 'data': []};
      }
    }
  }

  getGlobalProducts2({String? search}) async {
    List<Product> globalArray = [];
    List<String> countriesSupportingIsrael = [
      'United States',
      'Canada',
      'United Kingdom',
      'Germany',
      'France',
      'Australia',
      'India',
      'Italy',
      'Netherlands',
      'Greece',
      'Czech Republic',
      'Hungary',
      'Romania',
      'Bulgaria',
      'Austria',
    ];

    try {
      try {
        of.ProductSearchQueryConfiguration configuration =
            of.ProductSearchQueryConfiguration(
          version: of.ProductQueryVersion.v3,
          parametersList: <of.Parameter>[
            of.SearchTerms(
              terms: [search!],
            ),
          ],
        );
        /* of.ProductQueryConfiguration conf = of.ProductQueryConfiguration(
          '0048151623426',
          version: of.ProductQueryVersion.v3,
        );*/

        of.SearchResult result = await of.OpenFoodAPIClient.searchProducts(
          of.User(userId: '', password: ''),
          configuration,
        );
        globalArray = result.products!.map((e) {
          int isAlternative = 1;
          countriesSupportingIsrael.forEach((element) {
            if (e.countries!.toLowerCase().contains(element.toLowerCase()))
              isAlternative = 0;
          });

          return Product(
              name: e.productName,
              details: '${e.brands}-${e.countries}',
              image: e.imageFrontUrl,
              isAlternative: isAlternative);
        }).toList();
      } catch (e) {
        globalArray = [];
      }

      return {'message': 'success', 'data': globalArray};
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
