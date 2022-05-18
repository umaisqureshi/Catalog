


class GetCategoryList {
  List<GetCategory> category;

  GetCategoryList({this.category});

  GetCategoryList.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category.add(new GetCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetCategory {
  String sId;
  String categoryImg;
  GetCategoryItem category;
  String createdAt;

  GetCategory({this.sId, this.categoryImg,this.category,this.createdAt});

  GetCategory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryImg = json['category_img'];
    category = json['category'] != null
        ? new GetCategoryItem.fromJson(json['category'])
        : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['category_img'] = this.categoryImg;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class GetCategoryItem {
  List<String> categoryFilters;
  List<String> subCategoryFilters;
  String category;
  bool genderSpecific;
  List<int> genderSpecificList;

  GetCategoryItem(
      {this.categoryFilters,
        this.subCategoryFilters,
        this.category,
        this.genderSpecific,
        this.genderSpecificList});

  GetCategoryItem.fromJson(Map<String, dynamic> json) {
    categoryFilters = json['category_filters'].cast<String>();
    subCategoryFilters = json['sub_category_filters'].cast<String>();
    category = json['category'];
    genderSpecific = json['gender_specific'];
    genderSpecificList = json['gender_specific_list'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_filters'] = this.categoryFilters;
    data['sub_category_filters'] = this.subCategoryFilters;
    data['category'] = this.category;
    data['gender_specific'] = this.genderSpecific;
    data['gender_specific_list'] = this.genderSpecificList;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GetCategoryItem &&
              runtimeType == other.runtimeType &&
              categoryFilters == other.categoryFilters &&
              subCategoryFilters == other.subCategoryFilters &&
              category == other.category &&
              genderSpecific == other.genderSpecific &&
              genderSpecificList == other.genderSpecificList;

  @override
  int get hashCode =>
      categoryFilters.hashCode ^
      subCategoryFilters.hashCode ^
      category.hashCode ^
      genderSpecific.hashCode ^
      genderSpecificList.hashCode;
}