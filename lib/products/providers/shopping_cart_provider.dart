import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item_shopping_cart_model.dart';

final shoppingCartNotifierProvider = StateNotifierProvider.autoDispose<ShoppingCartNotifier, AsyncValue<List<ItemShoppingCartModel>>>((ref) {
  ref.keepAlive();
  return ShoppingCartNotifier(ref);
});

class ShoppingCartNotifier extends StateNotifier<AsyncValue<List<ItemShoppingCartModel>>> {
  final StateNotifierProviderRef ref;

  ShoppingCartNotifier(this.ref) : super(const AsyncLoading());

  Future<void> fetchShoppingCart() async {
    ref.read(isShowLoadingFetchCartProvider.notifier).update((state) => true);
    await Future.delayed(const Duration(seconds: 1));
    ref.read(isShowLoadingFetchCartProvider.notifier).update((state) => false);
    List<ItemShoppingCartModel>? temp = state.value ?? [];
    state = AsyncData(temp);
  }

  Future<void> addToCart(ItemShoppingCartModel product) async {
    ref.read(isShowLoadingAddToCartProvider.notifier).update((state) => true);
    await Future.delayed(const Duration(seconds: 1));
    List<ItemShoppingCartModel> temp = state.value ?? [];
    temp.insert(0, product);
    ref.read(isShowLoadingAddToCartProvider.notifier).update((state) => false);
    state = AsyncData(temp);
  }

  void incrementOrDecrementQuantity(int productId, int type) {
    List<ItemShoppingCartModel> temp = state.value ?? [];
    int indexItem = temp.indexWhere((element) => element.product!.id == productId);
    temp[indexItem].quantity = temp[indexItem].quantity! + type;
    if (temp[indexItem].quantity! <= 0) {
      temp.removeAt(indexItem);
    }
    state = AsyncData(temp);
  }

  Future<void> removeFromCart(int productId) async {
    List<ItemShoppingCartModel>? temp = state.value ?? [];
    temp.removeWhere((element) => element.product!.id == productId);
    state = AsyncData(temp);
  }

  Future<void> removeAllCart() async {
    List<ItemShoppingCartModel>? temp = state.value ?? [];
    temp.removeRange(0, state.value!.length);
    state = AsyncData(temp);
  }
}

final isShowLoadingAddToCartProvider = StateProvider.autoDispose<bool>((ref) => false);
final isShowLoadingFetchCartProvider = StateProvider.autoDispose<bool>((ref) => false);
