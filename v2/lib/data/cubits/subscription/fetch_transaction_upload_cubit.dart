import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eClassify/data/Repositories/bid_coins.dart';
import 'package:eClassify/data/Repositories/subscription_repository.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:path/path.dart' as path;

abstract class FetchBidTransactionUploadState {}

class FetchTransactionUploadInitial extends FetchBidTransactionUploadState {}

class FetchTransactionUploadInProgress extends FetchBidTransactionUploadState {}

class FetchTransactionUploadSuccess extends FetchBidTransactionUploadState {
  final String message;
  FetchTransactionUploadSuccess(this.message);
}

class FetchTransactionFailure extends FetchBidTransactionUploadState {
  final String errorMessage;

  FetchTransactionFailure(this.errorMessage);
}

class FetcTransactionUploadCubit extends Cubit<FetchBidTransactionUploadState> {
  FetcTransactionUploadCubit() : super(FetchTransactionUploadInitial());

  SubscriptionRepository repository = SubscriptionRepository();

  Future<void> uploadProff({
    required String id,
    required String pgId,
    required String paymentdate,
    required String amount,
    required String accountNumber,
    required String shippingfee,
    required String shippingservice,
    required String shippingetd,
    required File imageFile,
  }) async {
    try {
      emit(FetchTransactionUploadInProgress());

      // List<int> imageBytes = imageFile.readAsBytesSync();
      // String base64Image = base64.encode(imageBytes);

      Map<String, dynamic> params = {
        "item_id": id,
        "pg_id": pgId,
        "paymentdate": paymentdate,
        "amount": amount,
        "accnum": accountNumber,
        'shippingfee': shippingfee,
        'shippingservice': shippingservice,
        'shippingetd': shippingetd,
      };

      MultipartFile image = await MultipartFile.fromFile(imageFile.path, filename: path.basename(imageFile.path));

      params.addAll({
        "uploadProof": image,
      });

      // sdfsdfsdf
      var result = await repository.createUploadPayment(params);

      emit(FetchTransactionUploadSuccess(result));
    } catch (e) {
      if (!isClosed) {
        emit(FetchTransactionFailure(e.toString()));
      }
    }
  }
}
