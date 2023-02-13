import 'package:demo_riverpod/products/models/product_model.dart';
import 'package:demo_riverpod/products/providers/product_provider.dart';
import 'package:demo_riverpod/products/widgets/card_item_product_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

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
    super.initState();
    ref.read(productsNotifier.notifier).fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = ref.watch(productsNotifier);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                              onTap: () {},
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
                      data: (products) => ListView.builder(
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
                        child: CircularProgressIndicator(color: Colors.green),
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
