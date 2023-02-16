import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/product_model.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(searchResultNotifierProvider.notifier).searchProduct(widget.searchText ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<ProductModel>> searchResultProvider = ref.watch(searchResultNotifierProvider);
    String searchText = ref.watch(searchTextProvider(widget.searchText ?? ""));
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
            onTap: () => ref.read(searchResultNotifierProvider.notifier).searchProduct(widget.searchText ?? ""),
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
              "Search $searchText",
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                child: searchResultProvider.when(
                  data: (state) => state.isEmpty
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
                          itemCount: state.length,
                          itemBuilder: (_, index) => CardItemProductWidget(product: state[index]),
                        ),
                  error: (error, _) => Container(),
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
