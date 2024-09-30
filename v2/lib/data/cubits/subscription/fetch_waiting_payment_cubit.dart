import 'package:eClassify/data/Repositories/bid_coins.dart';
import 'package:eClassify/data/Repositories/subscription_repository.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/data_output.dart';

abstract class FetchWaitingPaymentState {}

class FetchWaitingPaymentInitial extends FetchWaitingPaymentState {}

class FetchWaitingPaymentInProgress extends FetchWaitingPaymentState {}

class FetchWaitingPaymentSuccess extends FetchWaitingPaymentState {
  final List<ItemModel> historyData;

  FetchWaitingPaymentSuccess({
    required this.historyData,
  });

  FetchWaitingPaymentSuccess copyWith({
    List<ItemModel>? historyData,
  }) {
    return FetchWaitingPaymentSuccess(historyData: historyData ?? this.historyData);
  }
}

class FetchWaitingPaymentFailure extends FetchWaitingPaymentState {
  final String errorMessage;

  FetchWaitingPaymentFailure(this.errorMessage);
}

class FetchWaitingPaymentCubit extends Cubit<FetchWaitingPaymentState> {
  FetchWaitingPaymentCubit() : super(FetchWaitingPaymentInitial());

  SubscriptionRepository repository = SubscriptionRepository();

  Future<void> getWaitingPayment() async {
    try {
      emit(FetchWaitingPaymentInProgress());

      DataOutput<ItemModel> result = await repository.getWaitingPayment();

      emit(FetchWaitingPaymentSuccess(historyData: result.modelList));
    } catch (e) {
      if (!isClosed) {
        emit(FetchWaitingPaymentFailure(e.toString()));
      }
    }
  }
}
