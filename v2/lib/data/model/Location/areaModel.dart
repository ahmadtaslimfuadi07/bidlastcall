class AreaModel {
  int? id;
  String? name;
  int? cityId;
  int? stateId;
  String? stateCode;
  int? countryId;
  String? createdAt;
  String? updatedAt;

  AreaModel({this.id, this.name, this.cityId, this.stateId, this.stateCode, this.countryId, this.createdAt, this.updatedAt});

  AreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    stateCode = json['state_code'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['city_id'] = this.cityId;
    data['state_id'] = this.stateId;
    data['state_code'] = this.stateCode;
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ProvinceModel {
  String? provinceId;
  String? province;

  ProvinceModel({this.provinceId, this.province});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id'];
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['province_id'] = this.provinceId;
    data['province'] = this.province;
    return data;
  }
}

class CityModel {
  String? cityId;
  String? provinceId;
  String? province;
  String? type;
  String? cityName;
  String? postalCode;

  CityModel({this.cityId, this.provinceId, this.province, this.type, this.cityName, this.postalCode});

  CityModel.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    provinceId = json['province_id'];
    province = json['province'];
    type = json['type'];
    cityName = json['city_name'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['province_id'] = this.provinceId;
    data['province'] = this.province;
    data['type'] = this.type;
    data['city_name'] = this.cityName;
    data['postal_code'] = this.postalCode;
    return data;
  }
}

class DistrictModel {
  String? subdistrictId;
  String? provinceId;
  String? province;
  String? cityId;
  String? city;
  String? type;
  String? subdistrictName;
  String? postalCode;

  DistrictModel({this.subdistrictId, this.provinceId, this.province, this.cityId, this.city, this.type, this.subdistrictName, this.postalCode});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    subdistrictId = json['subdistrict_id'];
    provinceId = json['province_id'];
    province = json['province'];
    cityId = json['city_id'];
    city = json['city'];
    type = json['type'];
    subdistrictName = json['subdistrict_name'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subdistrict_id'] = this.subdistrictId;
    data['province_id'] = this.provinceId;
    data['province'] = this.province;
    data['city_id'] = this.cityId;
    data['city'] = this.city;
    data['type'] = this.type;
    data['subdistrict_name'] = this.subdistrictName;
    data['postal_code'] = this.postalCode;
    return data;
  }
}
