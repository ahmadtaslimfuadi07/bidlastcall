import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eClassify/data/Repositories/bid_coins.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:path/path.dart' as path;

abstract class FetchBidCoinsCubitUploadState {}

class FetchBidCoinsUploadInitial extends FetchBidCoinsCubitUploadState {}

class FetchBidCoinsUploadInProgress extends FetchBidCoinsCubitUploadState {}

class FetchBidCoinsUploadSuccess extends FetchBidCoinsCubitUploadState {
  final String message;
  FetchBidCoinsUploadSuccess(this.message);
}

class FetchBidCoinsFailure extends FetchBidCoinsCubitUploadState {
  final String errorMessage;

  FetchBidCoinsFailure(this.errorMessage);
}

class FetcBidCoinsUploadCubit extends Cubit<FetchBidCoinsCubitUploadState> {
  FetcBidCoinsUploadCubit() : super(FetchBidCoinsUploadInitial());

  final BidCoinsRepository _bidCoinsRepository = BidCoinsRepository();

  Future<void> uploadProff({
    required String id,
    required String bank,
    required String accountName,
    required String accountNumber,
    required File imageFile,
  }) async {
    try {
      emit(FetchBidCoinsUploadInProgress());

      // List<int> imageBytes = imageFile.readAsBytesSync();
      // String base64Image = base64.encode(imageBytes);

      Map<String, dynamic> params = {
        'bidcoin_package_id': id,
        'bank': bank,
        'accountname': accountName,
        'accountnum': accountNumber,
      };

      MultipartFile image = await MultipartFile.fromFile(imageFile.path, filename: path.basename(imageFile.path));

      params.addAll({
        "uploadProof": image,
      });
      // sdfsdfsdf
      var result = await _bidCoinsRepository.createUploadPayment(params);

      emit(FetchBidCoinsUploadSuccess(result));
    } catch (e) {
      if (!isClosed) {
        emit(FetchBidCoinsFailure(e.toString()));
      }
    }
  }
}
