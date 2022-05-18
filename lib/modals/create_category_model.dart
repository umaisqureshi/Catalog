

import 'package:flutter/foundation.dart';

enum GenderSpecific {Men,Women,Kids}
extension GenderSpecificExt on GenderSpecific {
  String get name =>  describeEnum(this);
}

class CreateCategory {
  CreateCategory({
    this.searchFilters,
    this.subCategoryFilters,
    this.category,
    this.genderSpecific,
    this.genderSpecificList
  });

  List<String> searchFilters;
  List<String> subCategoryFilters;
  String category;
  bool genderSpecific;
  List<int> genderSpecificList;


  Map<String, dynamic> toJson() => {
    "category_filters": List<dynamic>.from(searchFilters.map((x) => x)),
    "sub_category_filters": List<dynamic>.from(subCategoryFilters.map((x) => x)),
    "category": category,
    "gender_specific": genderSpecific,
    "gender_specific_list": List<dynamic>.from(genderSpecificList.map((x) => x)),
  };
}