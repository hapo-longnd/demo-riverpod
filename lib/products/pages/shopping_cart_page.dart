import 'package:demo_riverpod/products/providers/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/item_shopping_cart_model.dart';
import '../widgets/card_item_product_widget.dart';

class ShoppingCartPage extends ConsumerStatefulWidget {
  const ShoppingCartPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends ConsumerState<ShoppingCartPage> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(shoppingCartNotifierProvider.notifier).fetchShoppingCart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<ItemShoppingCartModel>> shoppingCartProvider = ref.watch(shoppingCartNotifierProvider);
    bool isShowLoadingFetchCart = ref.watch(isShowLoadingFetchCartProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Shopping Cart",
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () => ref.read(shoppingCartNotifierProvider.notifier).removeAllCart(),
              child: const Icon(
                Icons.delete_outline,
                size: 26,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isShowLoadingFetchCart
            ? const Center(
                child: SpinKitCircle(color: Colors.green, size: 26),
              )
            : shoppingCartProvider.when(
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
                          product: products[index].product,
                          quantityInShoppingCart: products[index].quantity,
                          isInFavoriteList: false,
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
