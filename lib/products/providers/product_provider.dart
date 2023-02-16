import 'dart:async';
import 'package:demo_riverpod/products/service/product_datasource.dart';
import 'package:demo_riverpod/products/service/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final productDataSource = Provider.autoDispose((ref) => ProductDataSource());

final productRepository = Provider.autoDispose((ref) {
  final productDatasource = ref.watch(productDataSource);
  return ProductRepository(productDatasource);
});

final productsNotifierProvider = StateNotifierProvider.autoDispose<ProductsNotifier, AsyncValue<List<ProductModel>>>((ref) {
  return ProductsNotifier(ref.watch(productRepository), ref);
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final ProductRepository _productRepository;
  final StateNotifierProviderRef ref;

  ProductsNotifier(this._productRepository, this.ref) : super(const AsyncLoading());

  Future<void> fetchProduct({int? limit, int? offset}) async {
    state = const AsyncLoading();
    await _productRepository.fetchProduct(limit: limit, offset: offset).then((value) {
      if (value.hasValue) {
        List<ProductModel> temp = value.asData!.value;
        temp.removeWhere((element) => element.images!.any((el) => !el.contains("http")));
        state = AsyncData(temp);
      } else {
        state = AsyncError(value.asError!.error.toString(), StackTrace.current);
      }
    });
  }

  Future<void> updateProduct(ProductModel product) async {
    ref.read(messageResultUpdateProductProvider.notifier).update((state) => {});
    ref.read(isShowLoadingUpdateProductProvider.notifier).update((state) => true);
    await _productRepository.updateProduct(product).then((value) {
      ref.read(isShowLoadingUpdateProductProvider.notifier).update((state) => false);
      if (value.hasValue) {
        ref.read(messageResultUpdateProductProvider.notifier).update((state) => {"isSuccess": true, "message": value.value ?? ""});
        fetchProduct();
      } else {
        ref.read(messageResultUpdateProductProvider.notifier).update((state) => {"isSuccess": false, "message": value.asError!.error.toString()});
      }
    });
  }

  Future<void> deleteProduct(int productId) async {
    ref.read(messageResultDeleteProductProvider.notifier).update((state) => {});
    ref.read(showLoadingDeleteProductProvider.notifier).update((state) => {"isShowLoading": true, "idProduct": productId});
    await _productRepository.deleteProduct(productId).then((value) {
      ref.read(showLoadingDeleteProductProvider.notifier).update((state) => {"isShowLoading": false, "idProduct": productId});
      if (value.hasValue) {
        ref.read(messageResultDeleteProductProvider.notifier).update((state) => {"isSuccess": true, "message": value.value ?? ""});
        fetchProduct();
      } else {
        ref.read(messageResultDeleteProductProvider.notifier).update((state) => {"isSuccess": true, "message": value.asError!.error.toString()});
      }
    });
  }
}

final isShowLoadingUpdateProductProvider = StateProvider.autoDispose<bool>((ref) => false);
final messageResultUpdateProductProvider = StateProvider.autoDispose<Map<String, dynamic>>((ref) => {});

final showLoadingDeleteProductProvider = StateProvider.autoDispose<Map<String, dynamic>>((ref) => {});
final messageResultDeleteProductProvider = StateProvider.autoDispose<Map<String, dynamic>>((ref) => {});