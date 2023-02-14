import 'package:demo_riverpod/products/providers/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final searchTextProvider = StateProvider.autoDispose<String>((ref) => "");

final searchResultProvider = StateProvider.autoDispose<List<ProductModel>>((ref) {
  String searchText = ref.watch(searchTextProvider);
  AsyncValue<List<ProductModel>> listProduct = ref.watch(productsNotifier);
  return listProduct.value!.where((element) => element.title!.contains(searchText)).toList();
});
