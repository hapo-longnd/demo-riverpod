import 'package:demo_riverpod/products/pages/search_result_page.dart';
import 'package:demo_riverpod/products/pages/shopping_cart_page.dart';
import 'package:demo_riverpod/products/providers/product_provider.dart';
import 'package:demo_riverpod/products/widgets/card_item_product_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(productsNotifier.notifier).fetchProduct();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = ref.watch(productsNotifier);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.8),
          centerTitle: true,
          title: const Text(
            "Product Page",
            style: TextStyle(
              color: Colors.green,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: InkWell(
            onTap: () => ref.read(productsNotifier.notifier).fetchProduct(),
            child: const Icon(
              Icons.replay_circle_filled,
              color: Colors.green,
              size: 30,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
                ),
                child: const Icon(
                  Icons.shopping_cart_checkout,
                  size: 30,
                  color: Colors.green,
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormField(
                            controller: _searchController,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration.collapsed(
                              hintText: "Search...",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ).copyWith(
                              isDense: true,
                              contentPadding: const EdgeInsets.only(left: 16, right: 36, top: 8, bottom: 8),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            child: InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchResultWidget(searchText: _searchController.text),
                                  ),
                                );
                                _searchController.text = "";
                              },
                              child: const Icon(
                                Icons.search,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: productProvider.when(
                      data: (products) => products.isEmpty
                          ? const Text(
                              "No data",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (_, index) => CardItemProductWidget(product: products[index]),
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
        ),
      ),
    );
  }
}
