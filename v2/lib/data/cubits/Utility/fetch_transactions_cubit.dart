import 'package:eClassify/data/model/history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repositories/transaction.dart';
// import '../../model/data_output.dart';

abstract class FetchTransactionsState {}

class FetchTransactionsInitial extends FetchTransactionsState {}

class FetchTransactionsInProgress extends FetchTransactionsState {}

class FetchTransactionsSuccess extends FetchTransactionsState {
  final bool isLoadingMore;
  final bool loadingMoreError;
  final HistoryModel transactionmodel;

  FetchTransactionsSuccess({
    required this.isLoadingMore,
    required this.loadingMoreError,
    required this.transactionmodel,
  });

  FetchTransactionsSuccess copyWith({
    bool? isLoadingMore,
    bool? loadingMoreError,
    HistoryModel? transactionmodel,
  }) {
    return FetchTransactionsSuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadingMoreError: loadingMoreError ?? this.loadingMoreError,
      transactionmodel: transactionmodel ?? this.transactionmodel,
    );
  }
}

class FetchTransactionsFailure extends FetchTransactionsState {
  final String errorMessage;

  FetchTransactionsFailure(this.errorMessage);
}

class FetchTransactionsCubit extends Cubit<FetchTransactionsState> {
  FetchTransactionsCubit() : super(FetchTransactionsInitial());

  final TransactionRepository _transactionRepository = TransactionRepository();

  Future<void> fetchTransactions() async {
    try {
      emit(FetchTransactionsInProgress());

      HistoryModel result = await _transactionRepository.fetchTransactions();

      emit(FetchTransactionsSuccess(
        isLoadingMore: false,
        loadingMoreError: false,
        transactionmodel: result,
      ));
    } catch (e) {
      if (!isClosed) {
        emit(FetchTransactionsFailure(e.toString()));
      }
    }
  }

  // Future<void> fetchTransactionsMore() async {
  //   try {
  //     if (state is FetchTransactionsSuccess) {
  //       if ((state as FetchTransactionsSuccess).isLoadingMore) {
  //         return;
  //       }
  //       emit((state as FetchTransactionsSuccess).copyWith(isLoadingMore: true));
  //       DataOutput<HistoryModel> result = await _transactionRepository.fetchTransactions(
  //         page: (state as FetchTransactionsSuccess).page + 1,
  //       );

  //       FetchTransactionsSuccess transactionmodelState = (state as FetchTransactionsSuccess);
  //       transactionmodelState.transactionmodel.addAll(result.modelList);
  //       emit(FetchTransactionsSuccess(
  //           isLoadingMore: false, loadingMoreError: false, transactionmodel: transactionmodelState.transactionmodel, page: (state as FetchTransactionsSuccess).page + 1, total: result.total));
  //     }
  //   } catch (e) {
  //     emit((state as FetchTransactionsSuccess).copyWith(isLoadingMore: false, loadingMoreError: true));
  //   }
  // }

  // bool hasMoreData() {
  //   if (state is FetchTransactionsSuccess) {
  //     return (state as FetchTransactionsSuccess).transactionmodel.length < (state as FetchTransactionsSuccess).total;
  //   }
  //   return false;
  // }
}
