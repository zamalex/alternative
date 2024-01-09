import 'package:flutter/cupertino.dart';
import 'package:translatorclient/data/http/urls.dart';
import 'package:translatorclient/data/repository/home_repo.dart';
import 'package:translatorclient/data/repository/translators_repo.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/model/categories_model.dart';
import 'package:translatorclient/model/translators_model.dart';

class TranslatorsProvider extends ChangeNotifier {
  bool isLoading = false;

  List<Product> categoryTranslators = [];
  List<Product> allProducts = [];
  List<String> tags = [];

  int page = 1;
  int previous = -1;
  int? fromLanguage;
  int? toLanguage;
  int? category;

  initPage() {
    page = 1;
    previous = -1;
    /*fromLanguage = null;
    toLanguage = null;
    category = null;*/
    // categoryTranslators.clear();
    notifyListeners();
  }

  List<Product> getBrandProductsByID(int id) {
    return categoryTranslators
        .where((element) => element.brand_id == id)
        .toList();
  }

  initFilterPage() {
    fromLanguage = null;
    toLanguage = null;
    category = null;
    tags.clear();
    notifyListeners();
  }

  setCategory(int id) {
    category = id;
    notifyListeners();
  }

  setFromLanguage(int id) {
    fromLanguage = id;
    notifyListeners();
  }

  setToLanguage(int id) {
    toLanguage = id;
    notifyListeners();
  }

  addTag(String tag) {
    tags.add(tag);
    notifyListeners();
  }

  removeTag(String index) {
    tags.removeWhere((element) => element == index);
    notifyListeners();
  }

  Future getBrandProducts(int? id, int? p, {String? search, int? type}) async {
    List languages = [];
    List categories = [];
    List subCategories = [];

    if (search != null) initFilterPage();

    if (fromLanguage != null) languages.add(fromLanguage);
    if (toLanguage != null) languages.add(toLanguage);

    if (id != null) subCategories.add(id);
    if (category != null) categories.add(category);

    Map<String, dynamic> filter = {
      'tags[]': tags,
      'languages[]': languages.isNotEmpty ? languages : [],
      'categories[]': categories.isNotEmpty ? categories : [],
      'sub_categories[]': subCategories.isNotEmpty ? subCategories : [],
      'search': search,
    };

    if (p != null || search != null) initPage();

    if (page == previous) return;

    categoryTranslators.clear();
    isLoading = true;
    notifyListeners();

    Map response = await sl<TranslatorsRepository>()
        .getBrandProducts(id, page, filter: filter, search: search ?? ' ');

    previous = page;
    if (page == 1) {
      try {
        categoryTranslators = (response['data'] as List<Product>);
        if (type != null)
          categoryTranslators = categoryTranslators
                  .where((element) => element.isAlternative == type)
                  .toList() ??
              [];
      } catch (e) {
        isLoading = false;
        notifyListeners();
      }
    } else if (page > 1) {
      if (type != null)
        categoryTranslators = categoryTranslators
                .where((element) => element.isAlternative == type)
                .toList() ??
            [];
      categoryTranslators.addAll(response['data'] as List<Product>);
    }

    if ((response['data'] as List).isNotEmpty) {
      page++;
    }

    if (search != null && Url.GLOBALSEARCH) {
      if (search != ' ' && search!.isNotEmpty) {
        Map response2 = {'data': []};
        if (isNumeric(search)) {
          response2 = await sl<TranslatorsRepository>()
              .getGlobalProducts(search: search);
        } else {
          response2 = await sl<TranslatorsRepository>()
              .getGlobalProducts2(search: search);
        }

        categoryTranslators.addAll(response2['data'] as List<Product>);
      }
    }
    isLoading = false;
    notifyListeners();
  }

  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  Future getAllProducts(int? id, int? p, {String? search, int? type}) async {
    List languages = [];
    List categories = [];
    List subCategories = [];

    if (search != null) initFilterPage();

    if (fromLanguage != null) languages.add(fromLanguage);
    if (toLanguage != null) languages.add(toLanguage);

    if (id != null) subCategories.add(id);
    if (category != null) categories.add(category);

    Map<String, dynamic> filter = {
      'tags[]': tags,
      'languages[]': languages.isNotEmpty ? languages : [],
      'categories[]': categories.isNotEmpty ? categories : [],
      'sub_categories[]': subCategories.isNotEmpty ? subCategories : [],
      'search': search,
    };

    if (p != null || search != null) initPage();

    if (page == previous) return;

    allProducts.clear();
    isLoading = true;
    notifyListeners();

    Map response = await sl<TranslatorsRepository>()
        .getBrandProducts(id, page, filter: filter, search: search ?? ' ');

    previous = page;
    if (page == 1) {
      try {
        allProducts = (response['data'] as List<Product>);
        if (type != null)
          allProducts = allProducts
                  .where((element) => element.isAlternative == type)
                  .toList() ??
              [];
      } catch (e) {
        isLoading = false;
        notifyListeners();
      }
    } else if (page > 1) {
      if (type != null)
        allProducts = allProducts
                .where((element) => element.isAlternative == type)
                .toList() ??
            [];
      allProducts.addAll(response['data'] as List<Product>);
    }

    if ((response['data'] as List).isNotEmpty) {
      page++;
    }

    isLoading = false;
    notifyListeners();
  }

  List<Product> thisBrandProducts = [];
  Future getThisBrandProductsByBrnadID(int? id, {String? type}) async {
    isLoading = true;
    notifyListeners();

    Map response = await sl<TranslatorsRepository>()
        .getBrandProducts(id, page, filter: null, search: ' ');

    try {
      thisBrandProducts = (response['data'] as List<Product>);
      // if (type != null)
      thisBrandProducts = thisBrandProducts
              .where((element) => element.brand_id == id)
              .toList() ??
          [];
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  List<Product> alternativeProducts = [];
  Future getAlternativeProductsByID(int? id) async {
    isLoading = true;
    notifyListeners();

    Map response = await sl<TranslatorsRepository>()
        .getBrandProducts(id, page, filter: null, search: ' ');

    try {
      alternativeProducts = (response['data'] as List<Product>);
      alternativeProducts = alternativeProducts
              .where((element) => element.parent_product_id == id)
              .toList() ??
          [];
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }
}
