import 'package:demo_riverpod/products/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/product_model.dart';
import '../providers/favorite_list_provider.dart';
import '../providers/search_result_provider.dart';
import '../widgets/card_item_product_widget.dart';

class SearchResultWidget extends ConsumerStatefulWidget {
  final String? searchText;

  const SearchResultWidget({Key? key, this.searchText}) : super(key: key);

  @override
  ConsumerState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends ConsumerState<SearchResultWidget> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchTextProvider.notifier).state =
          "${RegExp(r'^-?[0-9]+$').hasMatch(widget.searchText ?? "") ? "Price" : "Title"} : ${widget.searchText}";
      ref.read(categoryNotifierProvider.notifier).fetchListCategory();
      ref.read(listProductSearchResultProvider.notifier).searchOrFilterProduct(widget.searchText ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<CategoryModel>> categoryProvider = ref.watch(categoryNotifierProvider);
    int categorySelected = ref.watch(categorySelectedProvider);

    AsyncValue<List<ProductModel>> listProductSearchResult = ref.watch(listProductSearchResultProvider);
    AsyncValue<List<ProductModel>> favoriteListProvider = ref.watch(favoriteListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Search Result Page",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              ref.read(categorySelectedProvider.notifier).state = 0;
              ref.read(listProductSearchResultProvider.notifier).searchOrFilterProduct(widget.searchText ?? "");
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: const Icon(
                Icons.replay_circle_filled,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search ${ref.watch(searchTextProvider)}",
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: categoryProvider.when(
                data: (categories) => categories.isEmpty
                    ? const Text(
                        "No data",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            categories.length,
                            (index) => InkWell(
                              onTap: () {
                                ref.read(categorySelectedProvider.notifier).state = categories[index].id!;
                                ref
                                    .read(listProductSearchResultProvider.notifier)
                                    .searchOrFilterProduct(widget.searchText ?? "", categoryIdSelected: categories[index].id!);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: index == categories.length - 1 ? 0 : 6),
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: categorySelected == categories[index].id ? Colors.orange : Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  categories[index].name ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                error: (Object error, StackTrace stackTrace) => Center(
                  child: Text(
                    error.toString(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                loading: () => const Center(
                  child: SpinKitCircle(color: Colors.green, size: 26),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                child: listProductSearchResult.when(
                  data: (products) => products.isEmpty
                      ? const Center(
                          child: Text(
                            "No data",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (_, index) => CardItemProductWidget(
                            product: products[index],
                            isInFavoriteList: favoriteListProvider.value!.indexWhere((element) => element.id == products[index].id) != -1,
                          ),
                        ),
                  error: (Object error, StackTrace stackTrace) => Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  loading: () => const Center(
                    child: SpinKitCircle(color: Colors.green, size: 26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
