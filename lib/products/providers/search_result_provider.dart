import 'package:demo_riverpod/products/models/category_model.dart';
import 'package:demo_riverpod/products/providers/product_provider.dart';
import 'package:demo_riverpod/products/service/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final searchTextProvider = StateProvider.autoDispose<String>((ref) => "");

final categorySelectedProvider = StateProvider.autoDispose<int>((ref) => 0);

final listProductSearchResultProvider = StateNotifierProvider.autoDispose<ListProductSearchResultNotifier, AsyncValue<List<ProductModel>>>((ref) {
  return ListProductSearchResultNotifier(ref);
});

class ListProductSearchResultNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final StateNotifierProviderRef ref;

  ListProductSearchResultNotifier(this.ref) : super(const AsyncLoading());

  Future<void> searchOrFilterProduct(String searchText, {int? categoryIdSelected}) async {
    state = const AsyncLoading();
    AsyncValue<List<ProductModel>> productProvider = ref.read(productsNotifierProvider);
    List<ProductModel> temp = productProvider.value!
        .where((element) => searchText.contains("Price")
            ? element.price.toString().contains(searchText.split(":").last)
            : element.title!.contains(searchText.split(":").last))
        .toList();
    if (categoryIdSelected != null && categoryIdSelected != 0) {
      temp.removeWhere((element) => element.category!.id != categoryIdSelected);
    }
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncData(temp);
  }
}

final categoryNotifierProvider = StateNotifierProvider.autoDispose<CategoryResultNotifier, AsyncValue<List<CategoryModel>>>((ref) {
  return CategoryResultNotifier(ref, ref.watch(productRepository));
});

class CategoryResultNotifier extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final StateNotifierProviderRef ref;
  final ProductRepository productRepository;

  CategoryResultNotifier(this.ref, this.productRepository) : super(const AsyncLoading());

  Future<void> fetchListCategory() async {
    state = const AsyncLoading();
    await productRepository.fetchListCategory().then((value) {
      if (value.hasValue) {
        List<CategoryModel> temp = value.asData!.value;
        state = AsyncData(temp);
      } else {
        state = AsyncError(value.asError!.error.toString(), StackTrace.current);
      }
    });
  }
}
