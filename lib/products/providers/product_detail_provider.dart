import 'package:demo_riverpod/products/providers/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';
import '../service/product_repository.dart';

final productsDetailNotifierProvider = StateNotifierProvider.autoDispose.family<ProductDetailNotifier, AsyncValue<ProductModel>, int>((ref, productId) {
  return ProductDetailNotifier(ref.watch(productRepository), ref, productId);
});

class ProductDetailNotifier extends StateNotifier<AsyncValue<ProductModel>> {
  final ProductRepository _productRepository;
  final StateNotifierProviderRef ref;
  final int productId;

  ProductDetailNotifier(this._productRepository, this.ref, this.productId) : super(const AsyncLoading());

  Future<void> fetchProductDetail() async {
    state = const AsyncLoading();
    await _productRepository.fetchProductDetail(productId).then((value) {
      if (value.hasValue) {
        state = AsyncData(value.asData!.value);
      } else {
        state = AsyncError(value.asError!.error.toString(), StackTrace.current);
      }
    });
  }
}

final errorMessageAddToCardProvider = StateProvider.autoDispose<String>((ref) => "");
