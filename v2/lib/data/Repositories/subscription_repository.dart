import 'dart:io';

import 'package:eClassify/data/model/item/item_model.dart';
import 'package:eClassify/data/model/pgsModel.dart';
import 'package:flutter/foundation.dart';

import '../../utils/api.dart';
import '../model/data_output.dart';
import '../model/subscription_pacakage_model.dart';

class SubscriptionRepository {
  Future<DataOutput<ItemModel>> getWaitingPayment() async {
    try {
      Map<String, dynamic> parameters = {
        //Api.page:page
      };

      Map<String, dynamic> response = await Api.get(url: Api.getWaitingPayment, queryParameters: parameters);

      List<ItemModel> transactionList = (response['data'] as List).map((e) => ItemModel.fromJson(e)).toList();

      return DataOutput<ItemModel>(total: transactionList.length, modelList: transactionList);
    } catch (e) {
      debugPrint("error get history ${e.toString()}");
      rethrow;
    }
  }

  Future<String> createUploadPayment(Map<String, dynamic> parameters) async {
    try {
      Map<String, dynamic> response = await Api.post(url: Api.payItem, parameter: parameters);

      return response['message'];
    } catch (e) {
      debugPrint("error get history ${e.toString()}");
      rethrow;
    }
  }

  Future<DataOutput<PGSModel>> getPaymentMetode() async {
    try {
      Map<String, dynamic> parameters = {
        //Api.page:page
      };

      Map<String, dynamic> response = await Api.get(url: Api.getPgs, queryParameters: parameters);

      List<PGSModel> transactionList = (response['data'] as List).map((e) => PGSModel.fromJson(e)).toList();

      return DataOutput<PGSModel>(total: transactionList.length, modelList: transactionList);
    } catch (e) {
      debugPrint("error get history ${e.toString()}");
      rethrow;
    }
  }

  Future<DataOutput<SubscriptionPackageModel>> getSubscriptionPacakges({required String type}) async {
    Map<String, dynamic> response = await Api.get(url: Api.getPackageApi, queryParameters: {if (Platform.isIOS) "platform": "ios", "type": type});

    List<SubscriptionPackageModel> modelList = (response['data'] as List).map((element) => SubscriptionPackageModel.fromJson(element)).toList();
    List<SubscriptionPackageModel> combineList = [];
    List<SubscriptionPackageModel> activeModelList = modelList.where((item) => item.isActive == true).toList();
    combineList.addAll(activeModelList);
    List<SubscriptionPackageModel> inactiveModelList = modelList.where((item) => item.isActive == false).toList();
    combineList.addAll(inactiveModelList);

    return DataOutput(total: combineList.length, modelList: combineList);
  }

  Future<void> subscribeToPackage(int packageId, bool isPackageAvailable) async {
    try {
      Map<String, dynamic> parameters = {
        Api.packageId: packageId,
        if (isPackageAvailable) 'flag': 1,
      };
      // if (isPackageAvailable) {
      //   parameters['flag'] = 1;
      // }

      await Api.post(url: Api.userPurchasePackageApi, parameter: parameters);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
