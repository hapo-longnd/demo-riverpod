import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item_shopping_cart_model.dart';

final shoppingCartNotifier = StateNotifierProvider.autoDispose<ShoppingCartNotifier, AsyncValue<List<ItemShoppingCartModel>>>((ref) {
  ref.keepAlive();
  return ShoppingCartNotifier(ref);
});

class ShoppingCartNotifier extends StateNotifier<AsyncValue<List<ItemShoppingCartModel>>> {
  final StateNotifierProviderRef ref;

  ShoppingCartNotifier(this.ref) : super(const AsyncLoading());

  Future<void> fetchShoppingCart() async {
    ref.read(isShowLoadingFetchCartProvider.notifier).update((state) => true);
    await Future.delayed(const Duration(seconds: 2));
    ref.read(isShowLoadingFetchCartProvider.notifier).update((state) => false);
    List<ItemShoppingCartModel>? temp = state.value ?? [];
    state = AsyncData(temp);
  }

  Future<void> addToCart(ItemShoppingCartModel product) async {
    ref.read(isShowLoadingAddToCartProvider.notifier).update((state) => true);
    await Future.delayed(const Duration(seconds: 3));
    List<ItemShoppingCartModel> temp = state.value ?? [];
    temp.insert(0, product);
    ref.read(isShowLoadingAddToCartProvider.notifier).update((state) => false);
    state = AsyncData(temp);
  }

  Future<void> removeFromCart(int productId) async {
    List<ItemShoppingCartModel>? temp = state.value ?? [];
    temp.removeWhere((element) => element.product!.id == productId);
    state = AsyncData(temp);
  }

  Future<void> removeAllCart() async {
    state = const AsyncData([]);
  }
}

final isShowLoadingAddToCartProvider = StateProvider.autoDispose<bool>((ref) => false);
final isShowLoadingFetchCartProvider = StateProvider.autoDispose<bool>((ref) => false);
