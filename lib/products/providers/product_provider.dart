import 'dart:async';
import 'package:demo_riverpod/products/service/product_datasource.dart';
import 'package:demo_riverpod/products/service/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final productDataSource = Provider((ref) => ProductDataSource());

final productRepository = Provider((ref) {
  final productDatasource = ref.watch(productDataSource);
  return ProductRepository(productDatasource);
});

final productsNotifier = StateNotifierProvider<ProductsNotifier, AsyncValue<List<ProductModel>>>((ref) {
  return ProductsNotifier(ref.watch(productRepository));
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final ProductRepository _productRepository;

  ProductsNotifier(this._productRepository) : super(const AsyncLoading());

  Future<void> fetchProduct({int? limit, int? offset}) async {
    await _productRepository.fetchProduct(limit: limit, offset: offset).then((value) {
      if (value.hasValue) {
        state = AsyncData(value.asData!.value);
      } else {
        state = AsyncError(value.asError!.error.toString(), StackTrace.current);
      }
    });
  }
}
