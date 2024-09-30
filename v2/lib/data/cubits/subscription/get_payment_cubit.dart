import 'package:eClassify/data/Repositories/advertisement_repository.dart';
import 'package:eClassify/data/Repositories/subscription_repository.dart';
import 'package:eClassify/data/model/pgsModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GetPaymentState {}

class GetPaymentInitial extends GetPaymentState {}

class GetPaymentInProgress extends GetPaymentState {}

class GetPaymentInSuccess extends GetPaymentState {
  final List<PGSModel> pgsModel;

  GetPaymentInSuccess(this.pgsModel);
}

class GetPaymentFailure extends GetPaymentState {
  final dynamic error;

  GetPaymentFailure(this.error);
}

class GetPaymentCubit extends Cubit<GetPaymentState> {
  GetPaymentCubit() : super(GetPaymentInitial());
  SubscriptionRepository repository = SubscriptionRepository();

  void getPayment() async {
    emit(GetPaymentInProgress());

    repository.getPaymentMetode().then((value) {
      emit(GetPaymentInSuccess(value.modelList));
    }).catchError((e) {
      emit(GetPaymentFailure(e.toString()));
    });
  }
}
