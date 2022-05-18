export 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:category/api/storeApis.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/categoryModel.dart';
import 'package:translator/translator.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

final translator = GoogleTranslator();

const Color white = Colors.white;
const Color primary = Color.fromRGBO(21, 21, 21, 1);
const Color grey = Color.fromRGBO(240, 239, 239, 1);
const Color brown = Color(0xFFb58563);

const String defaultCurrency = "USD";

const String BASE_URL = "https://catalogmarket.server.ly";
//const String BASE_URL = "https://catalog-mobile-api.herokuapp.com";
//const String BASE_URL = "https://catalog-app-api.herokuapp.com";

List<String> locationList = <String>[
  'Tripoli',
  'Benghazi',
  'Misrata',
  'Az-Zawiyah',
  'Zliten',
  'Al Bayda',
  'Ajdabiya',
  'Derna'
];

List<String> genderList = <String>[
  'Male',
  'Female'
];

List<String> locationListArabic = <String>[
  'طرابلس',
  'بنغازي',
  'مصراتة',
  'الزاوية',
  'زليتن',
  'البيضاء',
  'أجدابيا',
  'درنة'
];

List<String> currenciesEnglish = <String>[
  "LYD",
  "USD",
  "EUR",
  "GBP",
];

List<String> currenciesArabic = <String>[
 "دينار ليبي",
"دولار أمريكي",
"يورو",
" جنيه إسترليني",
];

Map<String, List<String>> categoriesFilter = Map<String, List<String>>();
Map<String, List<String>> categoriesSubCate = Map<String, List<String>>();
Map<String, List<int>> categoriesGender = Map<String, List<int>>();
List<String> categoriesList = <String>[];
GetCategoryList categoriesObj = GetCategoryList();

Future<List<String>> getCategoriesData(String token)async{
  ApiResponse _apiRes = ApiResponse();

  _apiRes = await getCategories(token: token);
  if((_apiRes.ApiError as ApiError) == null){
    categoriesObj = _apiRes.Data;
    categoriesList.clear();
    categoriesFilter.clear();
    categoriesSubCate.clear();
    categoriesGender.clear();
    for(int i=0;i<categoriesObj.category.length; i++){
      categoriesList.add(categoriesObj.category[i].category.category);
      categoriesFilter.addAll({categoriesObj.category[i].category.category: categoriesObj.category[i].category.categoryFilters});
      categoriesSubCate.addAll({categoriesObj.category[i].category.category: categoriesObj.category[i].category.subCategoryFilters});
      categoriesGender.addAll({categoriesObj.category[i].category.category: categoriesObj.category[i].category.genderSpecificList});
    }
  }
  return categoriesList;
}

Future<File> fileFromImageUrl(String link) async {
  String imageName = link.split('/').last;
  print("IMAGE NAME :::::::::::::::::::::::::::::::::::::::: $imageName");
  final response = await http.get(Uri.parse(link));

  Directory tempDir = await getTemporaryDirectory();

  final file = File(join(tempDir.path, imageName));

  file.writeAsBytes(response.bodyBytes);

  return file;
}


