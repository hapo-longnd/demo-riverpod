import 'package:demo_riverpod/products/models/product_model.dart';
import 'package:demo_riverpod/products/pages/update_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/notifications.dart';
import '../providers/product_provider.dart';

class CardItemProductWidget extends ConsumerWidget {
  final ProductModel? product;

  CardItemProductWidget({Key? key, this.product}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  void _showNotificationDeleteProduct(BuildContext context, WidgetRef ref) {
    ref.listen(messageResultDeleteProductProvider, (previous, next) async {
      if (next["message"] != null) {
        await NotificationUtil.showNotificationSnackBar(context: context, content: next["message"], isSuccess: next["isSuccess"]);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _showNotificationDeleteProduct(context, ref);
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdateProductPage(product: product)),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        product!.images!.first,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product!.title ?? "",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Price : ${product!.price ?? ""}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Create : ${product!.creationAt != null ? product!.creationAt!.split("T").toList().first : ""}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProductPage(product: product)),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.edit_note,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ref.watch(showLoadingDeleteProductProvider)["idProduct"] == product!.id && ref.watch(showLoadingDeleteProductProvider)["isShowLoading"]
                  ? const SpinKitCircle(
                      color: Colors.black,
                      size: 24,
                    )
                  : InkWell(
                      onTap: () => ref.read(productsNotifier.notifier).deleteProduct(product!.id ?? 0),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.delete_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
