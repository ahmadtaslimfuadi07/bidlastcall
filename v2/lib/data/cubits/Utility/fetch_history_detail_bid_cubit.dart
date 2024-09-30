import 'package:eClassify/data/Repositories/bid_coins.dart';
import 'package:eClassify/data/model/item/item_detail_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FetchHistoryDetailBidState {}

class FetchHistoryDetailBidInitial extends FetchHistoryDetailBidState {}

class FetchHistoryDetailBidInProgress extends FetchHistoryDetailBidState {}

class FetchHistoryDetailBidSuccess extends FetchHistoryDetailBidState {
  final ItemDetailModel historyData;

  FetchHistoryDetailBidSuccess({
    required this.historyData,
  });

  FetchHistoryDetailBidSuccess copyWith({
    ItemDetailModel? historyData,
  }) {
    return FetchHistoryDetailBidSuccess(
      historyData: historyData ?? this.historyData,
    );
  }
}

class FetchHistoryDetailBidFailure extends FetchHistoryDetailBidState {
  final String errorMessage;

  FetchHistoryDetailBidFailure(this.errorMessage);
}

class FetchHistoryDetailBidCubit extends Cubit<FetchHistoryDetailBidState> {
  FetchHistoryDetailBidCubit() : super(FetchHistoryDetailBidInitial());

  final BidCoinsRepository _transactionRepository = BidCoinsRepository();

  Future<void> fetchHistoryDetailBid(int id) async {
    try {
      emit(FetchHistoryDetailBidInProgress());

      ItemDetailModel result = await _transactionRepository.fetchDetailHistoryBid(id);

      emit(FetchHistoryDetailBidSuccess(historyData: result));
    } catch (e) {
      if (!isClosed) {
        emit(FetchHistoryDetailBidFailure(e.toString()));
      }
    }
  }
}
