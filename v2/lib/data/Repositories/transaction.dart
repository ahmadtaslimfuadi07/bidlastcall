import 'package:eClassify/data/model/history_model.dart';

import '../../utils/api.dart';
import '../model/data_output.dart';

class TransactionRepository {
  Future<HistoryModel> fetchTransactions() async {
    Map<String, dynamic> parameters = {
      //Api.page:page
    };

    Map<String, dynamic> response = await Api.get(url: Api.getPaymentDetailsApi, queryParameters: parameters);

    // List<HistoryModel> transactionList = (response['data'] as List).map((e) => HistoryModel.fromJson(e)).toList();
    HistoryModel transactionList = HistoryModel.fromJson(response['data']);

    // return DataOutput<HistoryModel>(total: transactionList.length, modelList: transactionList);
    return transactionList;
  }
}
