import 'package:demo_riverpod/products/providers/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';
import '../service/product_repository.dart';

final productsDetailNotifier = StateNotifierProvider.autoDispose<ProductDetailNotifier, AsyncValue<ProductModel>>((ref) {
  return ProductDetailNotifier(ref.watch(productRepository), ref);
});

class ProductDetailNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final ProductRepository _productRepository;
  final StateNotifierProviderRef ref;

  ProductDetailNotifier(this._productRepository, this.ref) : super(const AsyncLoading());
}
