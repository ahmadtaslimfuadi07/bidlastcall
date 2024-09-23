import 'package:eClassify/data/Repositories/bid_coins.dart';
import 'package:eClassify/data/model/bid_coins_package_model.dart';
import 'package:eClassify/data/model/data_output.dart';
import 'package:eClassify/exports/main_export.dart';

abstract class FetchBidCoinsPackageCubitState {}

class FetchBidCoinsPackageInitial extends FetchBidCoinsPackageCubitState {}

class FetchBidCoinsPackageInProgress extends FetchBidCoinsPackageCubitState {}

class FetchBidCoinsPackageSuccess extends FetchBidCoinsPackageCubitState {
  final bool isLoadingMore;
  final bool loadingMoreError;
  final List<BidcoinsPackageModel> bidCoinsPackageModel;
  final int page;
  final int total;

  FetchBidCoinsPackageSuccess({
    required this.isLoadingMore,
    required this.loadingMoreError,
    required this.bidCoinsPackageModel,
    required this.page,
    required this.total,
  });

  FetchBidCoinsPackageSuccess copyWith({
    bool? isLoadingMore,
    bool? loadingMoreError,
    List<BidcoinsPackageModel>? bidCoinsPackageModel,
    int? page,
    int? total,
  }) {
    return FetchBidCoinsPackageSuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadingMoreError: loadingMoreError ?? this.loadingMoreError,
      bidCoinsPackageModel: bidCoinsPackageModel ?? this.bidCoinsPackageModel,
      page: page ?? this.page,
      total: total ?? this.total,
    );
  }
}

class FetchBidCoinsPackageFailure extends FetchBidCoinsPackageCubitState {
  final String errorMessage;

  FetchBidCoinsPackageFailure(this.errorMessage);
}

class FetcBidCoinsPackageCubit extends Cubit<FetchBidCoinsPackageCubitState> {
  FetcBidCoinsPackageCubit() : super(FetchBidCoinsPackageInitial());

  final BidCoinsRepository _bidCoinsRepository = BidCoinsRepository();

  Future<void> fetchPackage() async {
    try {
      emit(FetchBidCoinsPackageInProgress());

      DataOutput<BidcoinsPackageModel> result = await _bidCoinsRepository.fetchBidCoinsPackage();

      emit(FetchBidCoinsPackageSuccess(isLoadingMore: false, loadingMoreError: false, bidCoinsPackageModel: result.modelList, page: 1, total: result.total));
    } catch (e) {
      if (!isClosed) {
        emit(FetchBidCoinsPackageFailure(e.toString()));
      }
    }
  }
}
