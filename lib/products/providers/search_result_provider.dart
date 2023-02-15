import 'package:demo_riverpod/products/providers/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final searchTextProvider = StateProvider.autoDispose.family<String, String>((ref, searchText) {
  if (RegExp(r'^-?[0-9]+$').hasMatch(searchText)) {
    return "Price : $searchText";
  } else {
    return "Title : $searchText";
  }
});

final searchResultNotifier = StateNotifierProvider.autoDispose<SearchResultNotifier, AsyncValue<List<ProductModel>>>((ref) {
  return SearchResultNotifier(ref);
});

class SearchResultNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final StateNotifierProviderRef ref;

  SearchResultNotifier(this.ref) : super(const AsyncLoading());

  Future<void> searchProduct(String searchText) async {
    ref.read(searchTextProvider(searchText));
    state = const AsyncLoading();
    final listProduct = ref.read(productsNotifier);
    await Future.delayed(const Duration(seconds: 3));
    state = AsyncData(listProduct.value!
        .where((element) =>
            RegExp(r'^-?[0-9]+$').hasMatch(searchText) ? element.price.toString().contains(searchText) : element.title!.contains(searchText))
        .toList());
  }
}
