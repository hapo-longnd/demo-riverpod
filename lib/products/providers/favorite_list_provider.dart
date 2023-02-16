import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final favoriteListNotifierProvider = StateNotifierProvider.autoDispose<FavoriteListNotifier, AsyncValue<List<ProductModel>>>((ref) {
  ref.keepAlive();
  return FavoriteListNotifier(ref);
});

class FavoriteListNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final StateNotifierProviderRef ref;

  FavoriteListNotifier(this.ref) : super(const AsyncLoading());

  Future<void> fetchFavoriteList() async {
    ref.read(isShowLoadingFetchFavoriteListProvider.notifier).update((state) => true);
    await Future.delayed(const Duration(seconds: 1));
    ref.read(isShowLoadingFetchFavoriteListProvider.notifier).update((state) => false);
    List<ProductModel>? temp = state.value ?? [];
    state = AsyncData(temp);
  }

  Future<void> addToFavoriteList(ProductModel product) async {
    ref.read(isShowLoadingAddFavoriteListProvider(null).notifier).update((state) => {"status": true, "productId": null});
    await Future.delayed(const Duration(seconds: 1));
    List<ProductModel> temp = state.value ?? [];
    temp.insert(0, product);
    ref.read(isShowLoadingAddFavoriteListProvider(null).notifier).update((state) => {"status": false, "productId": null});
    state = AsyncData(temp);
  }

  Future<void> removeFromFavoriteList(int productId) async {
    ref.read(isShowLoadingAddFavoriteListProvider(productId).notifier).update((state) => {"status": true, "productId": productId});
    await Future.delayed(const Duration(seconds: 1));
    List<ProductModel>? temp = state.value ?? [];
    temp.removeWhere((element) => element.id == productId);
    ref.read(isShowLoadingAddFavoriteListProvider(productId).notifier).update((state) => {"status": false, "productId": productId});
    state = AsyncData(temp);
  }
}

final isShowLoadingAddFavoriteListProvider =
    StateProvider.autoDispose.family<Map<String, dynamic>, int?>((ref, productId) => {"status": false, "productId": null});
final isShowLoadingFetchFavoriteListProvider = StateProvider.autoDispose<bool>((ref) => false);
