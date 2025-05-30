import 'package:eClassify/Utils/api.dart';
import 'package:eClassify/data/model/data_output.dart';
import 'package:eClassify/data/model/item/item_model.dart';

import '../../model/Home/home_screen_section.dart';

class HomeRepository {
  Future<List<HomeScreenSection>> fetchHome({String? city, int? areaId}) async {
    try {
      Map<String, dynamic> parameters = {
        if (city != null && city != "") 'city': city,
        if (areaId != null && areaId != "") 'area_id': areaId,
      };

      Map<String, dynamic> response = await Api.get(url: Api.getFeaturedSectionApi, queryParameters: parameters);
      List<HomeScreenSection> homeScreenDataList = (response['data'] as List).map((element) {
        return HomeScreenSection.fromJson(element);
      }).toList();
      return homeScreenDataList;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataOutput<ItemModel>> fetchHomeAllItems({required int page, String? city, int? areaId}) async {
    try {
      Map<String, dynamic> parameters = {"page": page, if (city != null && city != "") 'city': city, if (areaId != null && areaId != "") 'area_id': areaId, "sort_by": "new-to-old"};

      Map<String, dynamic> response = await Api.get(url: Api.getItemApi, queryParameters: parameters);
      List<ItemModel> items = (response['data']['data'] as List).map((e) => ItemModel.fromJson(e)).toList();

      return DataOutput(total: response['data']['total'] ?? 0, modelList: items);
    } catch (error) {
      rethrow;
    }
  }

  Future<DataOutput<ItemModel>> fetchSectionItems({required int page, required int sectionId}) async {
    try {
      Map<String, dynamic> parameters = {"page": page, "featured_section_id": sectionId};

      Map<String, dynamic> response = await Api.get(url: Api.getItemApi, queryParameters: parameters);
      List<ItemModel> items = (response['data']['data'] as List).map((e) => ItemModel.fromJson(e)).toList();

      return DataOutput(total: response['data']['total'] ?? 0, modelList: items);
    } catch (error) {
      rethrow;
    }
  }
}
