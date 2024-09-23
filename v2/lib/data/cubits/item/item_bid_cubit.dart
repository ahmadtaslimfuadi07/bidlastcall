import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repositories/Item/item_repository.dart';

abstract class ItemBidState {}

class ItemBidInitial extends ItemBidState {}

class ItemBidInProgress extends ItemBidState {}

class ItemBidSuccess extends ItemBidState {
  final String message;
  ItemBidSuccess(this.message);
}

class ItemBidFailure extends ItemBidState {
  final String errorMessage;

  ItemBidFailure(this.errorMessage);
}

class ItemBidCubit extends Cubit<ItemBidState> {
  final ItemRepository _itemRepository = ItemRepository();

  ItemBidCubit() : super(ItemBidInitial());

  Future<void> itemBid(int id, int bidAmount, int bidPrice) async {
    try {
      emit(ItemBidInProgress());
      Map<String, dynamic> param = {'item_id': id, 'bid_amount': bidAmount, 'bid_price': bidPrice};
      var response = await _itemRepository.bidItem(param);
      emit(ItemBidSuccess(response));
    } catch (e) {
      emit(ItemBidFailure(e.toString()));
    }
  }
}
