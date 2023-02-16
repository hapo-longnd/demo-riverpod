import 'package:demo_riverpod/products/providers/favorite_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/product_model.dart';
import '../widgets/card_item_product_widget.dart';

class FavoriteListPage extends ConsumerStatefulWidget {
  const FavoriteListPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends ConsumerState<FavoriteListPage> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteListNotifierProvider.notifier).fetchFavoriteList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<ProductModel>> favoriteListProvider = ref.watch(favoriteListNotifierProvider);
    bool isShowLoadingFetchFavoriteList = ref.watch(isShowLoadingFetchFavoriteListProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Favorite List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isShowLoadingFetchFavoriteList
            ? const Center(
                child: SpinKitCircle(color: Colors.green, size: 26),
              )
            : favoriteListProvider.when(
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
                          isInFavoriteList: true,
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
    );
  }
}
