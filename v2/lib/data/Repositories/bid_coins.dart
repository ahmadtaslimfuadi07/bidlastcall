import 'package:eClassify/Utils/api.dart';
import 'package:eClassify/data/model/bid_coins_history_model.dart';
import 'package:eClassify/data/model/bid_coins_package_model.dart';
import 'package:eClassify/data/model/data_output.dart';
import 'package:eClassify/data/model/item/item_detail_model.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:flutter/material.dart';

class BidCoinsRepository {
  Future<DataOutput<ItemModel>> fetchBidTransactionHistory() async {
    try {
      Map<String, dynamic> parameters = {
        //Api.page:page
      };

      Map<String, dynamic> response = await Api.get(url: Api.getBidHistory, queryParameters: parameters);

      List<ItemModel> transactionList = (response['data'] as List).map((e) => ItemModel.fromJson(e)).toList();

      return DataOutput<ItemModel>(total: transactionList.length, modelList: transactionList);
    } catch (e) {
      debugPrint("error get history ${e.toString()}");
      rethrow;
    }
  }

  Future<ItemDetailModel> fetchDetailHistoryBid(int id) async {
    try {
      Map<String, dynamic> parameters = {
        'item_id': id,
      };

      Map<String, dynamic> response = await Api.get(url: Api.getItemDetail, queryParameters: parameters);

      ItemDetailModel transactionList = ItemDetailModel.fromJson(response['data']);

      return transactionList;
    } catch (e) {
      debugPrint("error get history ${e.toString()}");
      rethrow;
    }
  }

  Future<BidcoinsHistoryModel> fetchHistory() async {
    try {
      Map<String, dynamic> parameters = {
        //Api.page:page
      };

      Map<String, dynamic> response = await Api.get(url: Api.getBidCoinsListApi, queryParameters: parameters);

      BidcoinsHistoryModel transactionList = BidcoinsHistoryModel.fromJson(response['data']);

      return transactionList;
    } catch (e) {
      debugPrint("error get history ${e.toString()}");
      rethrow;
    }
  }

  Future<DataOutput<BidcoinsPackageModel>> fetchBidCoinsPackage() async {
    try {
      Map<String, dynamic> parameters = {
        //Api.page:page
      };

      Map<String, dynamic> response = await Api.get(url: Api.getBidCoinsPackageApi, queryParameters: parameters);

      List<BidcoinsPackageModel> transactionList = (response['data'] as List).map((e) => BidcoinsPackageModel.fromJson(e)).toList();

      return DataOutput<BidcoinsPackageModel>(total: transactionList.length, modelList: transactionList);
    } catch (e) {
      debugPrint("error get history ${e.toString()}");
      rethrow;
    }
  }

  Future<String> createUploadPayment(Map<String, dynamic> parameters) async {
    try {
      Map<String, dynamic> response = await Api.post(url: Api.postPurchaseBidcoinApi, parameter: parameters);

      return response['message'];
    } catch (e) {
      debugPrint("error get history ${e.toString()}");
      rethrow;
    }
  }
}
