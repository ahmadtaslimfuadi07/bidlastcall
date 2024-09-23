import 'package:eClassify/data/Repositories/bid_coins.dart';
import 'package:eClassify/data/model/bid_coins_history_model.dart';
import 'package:eClassify/exports/main_export.dart';

abstract class FetchBidCoinsCubitState {}

class FetchBidCoinsInitial extends FetchBidCoinsCubitState {}

class FetchBidCoinsInProgress extends FetchBidCoinsCubitState {}

class FetchBidCoinsSuccess extends FetchBidCoinsCubitState {
  final bool isLoadingMore;
  final bool loadingMoreError;
  final BidcoinsHistoryModel bidCoinsHistoryModel;
  final int page;
  final int total;

  FetchBidCoinsSuccess({
    required this.isLoadingMore,
    required this.loadingMoreError,
    required this.bidCoinsHistoryModel,
    required this.page,
    required this.total,
  });

  FetchBidCoinsSuccess copyWith({
    bool? isLoadingMore,
    bool? loadingMoreError,
    BidcoinsHistoryModel? bidCoinsHistoryModel,
    int? page,
    int? total,
  }) {
    return FetchBidCoinsSuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadingMoreError: loadingMoreError ?? this.loadingMoreError,
      bidCoinsHistoryModel: bidCoinsHistoryModel ?? this.bidCoinsHistoryModel,
      page: page ?? this.page,
      total: total ?? this.total,
    );
  }
}

class FetchBidCoinsFailure extends FetchBidCoinsCubitState {
  final String errorMessage;

  FetchBidCoinsFailure(this.errorMessage);
}

class FetcBidCoinsCubit extends Cubit<FetchBidCoinsCubitState> {
  FetcBidCoinsCubit() : super(FetchBidCoinsInitial());

  final BidCoinsRepository _bidCoinsRepository = BidCoinsRepository();

  Future<void> fetchHistory() async {
    try {
      emit(FetchBidCoinsInProgress());

      BidcoinsHistoryModel result = await _bidCoinsRepository.fetchHistory();

      emit(FetchBidCoinsSuccess(isLoadingMore: false, loadingMoreError: false, bidCoinsHistoryModel: result, page: 1, total: 1));
    } catch (e) {
      if (!isClosed) {
        print("fecth close");
        emit(FetchBidCoinsFailure(e.toString()));
      }
    }
  }

  int currbalance() {
    if (state is FetchBidCoinsSuccess) {
      return (state as FetchBidCoinsSuccess).bidCoinsHistoryModel.currbalance ?? 0;
    }
    return 0;

    // return state.bidCoinsHistoryModel.any((item) => item.id == itemId);
  }
}
