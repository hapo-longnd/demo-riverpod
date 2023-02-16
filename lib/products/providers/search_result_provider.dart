import 'package:demo_riverpod/products/models/category_model.dart';
import 'package:demo_riverpod/products/providers/product_provider.dart';
import 'package:demo_riverpod/products/service/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final searchTextProvider = StateProvider.autoDispose<String>((ref) => "");

final categorySelectedProvider = StateProvider.autoDispose<int>((ref) => 0);

final listProductSearchResultProvider = FutureProvider<List<ProductModel>>((ref) async {
  List<ProductModel> temp = [];
  String searchText = ref.read(searchTextProvider.notifier).state;
  temp = ref
      .read(productsNotifierProvider)
      .value!
      .where((element) => searchText.contains("Price")
          ? element.price.toString().contains(searchText.split(":").last)
          : element.title!.contains(searchText.split(":").last))
      .toList();
  return temp;
});

final listProductFilteredByCategoryNotifierProvider =
    StateNotifierProvider.autoDispose<ListProductFilteredNotifier, AsyncValue<List<ProductModel>>>((ref) {
  AsyncValue<List<ProductModel>> listProductSearched = ref.watch(listProductSearchResultProvider);
  return ListProductFilteredNotifier(ref, listProductSearched.value!);
});

class ListProductFilteredNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final StateNotifierProviderRef ref;
  final List<ProductModel> listProductSearched;

  ListProductFilteredNotifier(this.ref, this.listProductSearched) : super(const AsyncLoading());

  Future<void> filterProductByCategory(int categoryId) async {
    ref.read(categorySelectedProvider.notifier).state = categoryId;
    List<ProductModel> temp = listProductSearched;
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 2));
    if (categoryId != 0) {
      temp.removeWhere((element) => element.category!.id != categoryId);
    }
    state = AsyncData(temp);
  }
}

// ============================================================================================================

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
