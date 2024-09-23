import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repositories/Item/item_repository.dart';

abstract class ItemBuyNowState {}

class ItemBuyNowInitial extends ItemBuyNowState {}

class ItemBuyNowInProgress extends ItemBuyNowState {}

class ItemBuyNowSuccess extends ItemBuyNowState {
  final String message;
  ItemBuyNowSuccess(this.message);
}

class ItemBuyNowFailure extends ItemBuyNowState {
  final String errorMessage;

  ItemBuyNowFailure(this.errorMessage);
}

class ItemBuyNowCubit extends Cubit<ItemBuyNowState> {
  final ItemRepository _itemRepository = ItemRepository();

  ItemBuyNowCubit() : super(ItemBuyNowInitial());

  Future<void> itemBuyNow(int id, int buyPrice) async {
    try {
      emit(ItemBuyNowInProgress());
      Map<String, dynamic> param = {'item_id': id, 'buy_price': buyPrice};
      var response = await _itemRepository.buyNowItem(param);
      emit(ItemBuyNowSuccess(response));
    } catch (e) {
      emit(ItemBuyNowFailure(e.toString()));
    }
  }
}
