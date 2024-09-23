import 'package:eClassify/data/Repositories/bid_coins.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/data_output.dart';

abstract class FetchHistoryBidState {}

class FetchHistoryBidInitial extends FetchHistoryBidState {}

class FetchHistoryBidInProgress extends FetchHistoryBidState {}

class FetchHistoryBidSuccess extends FetchHistoryBidState {
  final bool isLoadingMore;
  final bool loadingMoreError;
  final List<ItemModel> historyData;
  final int page;
  final int total;

  FetchHistoryBidSuccess({
    required this.isLoadingMore,
    required this.loadingMoreError,
    required this.historyData,
    required this.page,
    required this.total,
  });

  FetchHistoryBidSuccess copyWith({
    bool? isLoadingMore,
    bool? loadingMoreError,
    List<ItemModel>? historyData,
    int? page,
    int? total,
  }) {
    return FetchHistoryBidSuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadingMoreError: loadingMoreError ?? this.loadingMoreError,
      historyData: historyData ?? this.historyData,
      page: page ?? this.page,
      total: total ?? this.total,
    );
  }
}

class FetchHistoryBidFailure extends FetchHistoryBidState {
  final String errorMessage;

  FetchHistoryBidFailure(this.errorMessage);
}

class FetchHistoryBidCubit extends Cubit<FetchHistoryBidState> {
  FetchHistoryBidCubit() : super(FetchHistoryBidInitial());

  final BidCoinsRepository _transactionRepository = BidCoinsRepository();

  Future<void> fetchHistoryBid() async {
    try {
      emit(FetchHistoryBidInProgress());

      DataOutput<ItemModel> result = await _transactionRepository.fetchBidTransactionHistory();

      emit(FetchHistoryBidSuccess(isLoadingMore: false, loadingMoreError: false, historyData: result.modelList, page: 1, total: result.total));
    } catch (e) {
      if (!isClosed) {
        emit(FetchHistoryBidFailure(e.toString()));
      }
    }
  }

  bool hasMoreData() {
    if (state is FetchHistoryBidSuccess) {
      return (state as FetchHistoryBidSuccess).historyData.length < (state as FetchHistoryBidSuccess).total;
    }
    return false;
  }
}
