import 'package:demo_riverpod/products/models/item_shopping_cart_model.dart';
import 'package:demo_riverpod/products/pages/shopping_cart_page.dart';
import 'package:demo_riverpod/products/providers/favorite_list_provider.dart';
import 'package:demo_riverpod/products/providers/product_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/product_model.dart';
import '../providers/shopping_cart_provider.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final int? productId;

  const ProductDetailPage({Key? key, this.productId}) : super(key: key);

  @override
  ConsumerState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(productsDetailNotifierProvider(widget.productId ?? -1).notifier).fetchProductDetail();
    });
    super.initState();
  }

  void _listenAddToCartSuccess() {
    ref.listen(isShowLoadingAddToCartProvider, (previous, next) {
      if (!next && previous != null && previous) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<ProductModel> productDetailProvider = ref.watch(productsDetailNotifierProvider(widget.productId ?? -1));

    bool isShowLoadingAddToShoppingCart = ref.watch(isShowLoadingAddToCartProvider);
    String errorMessageAddToCard = ref.watch(errorMessageAddToCardProvider);

    AsyncValue<List<ProductModel>> favoriteListProvider = ref.watch(favoriteListNotifierProvider);
    Map<String, dynamic> isShowLoadingAddToFavoriteList = ref.watch(isShowLoadingAddFavoriteListProvider(null));

    _listenAddToCartSuccess();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_checkout,
                          size: 26,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: const Offset(2, 2),
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: const Offset(-2, -2),
                      ),
                    ],
                  ),
                  child: productDetailProvider.when(
                    data: (product) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      product.images!.first,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title ?? "",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Create At : ${product.creationAt != null ? product.creationAt!.split(".").first : ""}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        product.description ?? "",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Price : ${product.price ?? ""}\u0024 / Product",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    child: TextFormField(
                                      controller: _quantityController,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration.collapsed(
                                        hintText: "0",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ).copyWith(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.all(8),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (errorMessageAddToCard.isNotEmpty) {
                                          ref.read(errorMessageAddToCardProvider.notifier).update((state) => "");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                !isShowLoadingAddToFavoriteList["status"]
                                    ? Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (favoriteListProvider.value!.indexWhere((element) => element.id == product.id) != -1) {
                                                ref.read(favoriteListNotifierProvider.notifier).removeFromFavoriteList(product.id!);
                                              } else {
                                                ref.read(favoriteListNotifierProvider.notifier).addToFavoriteList(product);
                                              }
                                            },
                                            child: Icon(
                                              Icons.favorite,
                                              color: favoriteListProvider.value!.indexWhere((element) => element.id == product.id) != -1
                                                  ? Colors.red
                                                  : Colors.grey,
                                              size: 24,
                                            ),
                                          ),
                                          const Text(
                                            "Add Favorite",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SpinKitCircle(color: Colors.grey, size: 18),
                              ],
                            ),
                            if (errorMessageAddToCard.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  errorMessageAddToCard,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (_quantityController.text.trim().isEmpty) {
                                  ref.read(errorMessageAddToCardProvider.notifier).update((state) => "This field is required to enter");
                                } else {
                                  if (!isShowLoadingAddToShoppingCart) {
                                    ref
                                        .read(shoppingCartNotifierProvider.notifier)
                                        .addToCart(ItemShoppingCartModel(quantity: int.parse(_quantityController.text), product: product));
                                  }
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.55,
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: isShowLoadingAddToShoppingCart
                                    ? const SpinKitCircle(color: Colors.white, size: 20)
                                    : const Text(
                                        "Add To Card",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    error: (error, _) => SizedBox(
                      height: 160,
                      child: Center(
                        child: Text(
                          error.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    loading: () => const SizedBox(
                      height: 160,
                      child: Center(
                        child: SpinKitCircle(color: Colors.green, size: 26),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
