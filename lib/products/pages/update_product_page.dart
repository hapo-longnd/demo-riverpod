import 'package:demo_riverpod/products/providers/update_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/notifications.dart';
import '../models/product_model.dart';
import '../models/validate_form_update_product_model.dart';
import '../providers/product_provider.dart';

class UpdateProductPage extends ConsumerStatefulWidget {
  final ProductModel? product;

  const UpdateProductPage({Key? key, this.product}) : super(key: key);

  @override
  ConsumerState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends ConsumerState<UpdateProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    ref.read(fetchDetailProductProvider(widget.product!.id ?? 0));
    super.initState();
  }

  void _showNotificationUpdateProduct() {
    ref.listen(messageResultUpdateProductProvider, (previous, next) async {
      if (next["message"] != null) {
        if (next["isSuccess"]) {
          Navigator.of(context).pop();
        }
        await NotificationUtil.showNotificationSnackBar(context: context, content: next["message"], isSuccess: next["isSuccess"]);
      }
    });
  }

  void _showNotificationFetchProductDetail() {
    ref.listen(errorMessageFetchProductDetailProvider, (previous, next) async {
      if (next.isNotEmpty) {
        await NotificationUtil.showNotificationSnackBar(context: context, content: next, isSuccess: false);
      }
      else{
        final productDetail = ref.watch(fetchDetailProductProvider(widget.product!.id ?? 0));
        _titleController.text = productDetail.asData!.value.title ?? "";
        _priceController.text = productDetail.asData!.value.price != null ? productDetail.asData!.value.price.toString() : "";
        _descriptionController.text = productDetail.asData!.value.description ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ValidateFormUpdateProductModel validateFormUpdateProductProvider = ref.watch(validateFormUpdateProductNotifier);
    _showNotificationUpdateProduct();
    _showNotificationFetchProductDetail();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Update Product Page",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration.collapsed(
                      hintText: "Title",
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
                    onChanged: (value) => ref.read(validateFormUpdateProductNotifier.notifier).validateFieldTitle(value),
                    onEditingComplete: () => ref.read(validateFormUpdateProductNotifier.notifier).validateFieldTitle(_titleController.text.trim()),
                  ),
                  if (validateFormUpdateProductProvider.errorMessageTitle != null && validateFormUpdateProductProvider.errorMessageTitle!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        validateFormUpdateProductProvider.errorMessageTitle ?? "",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Price",
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
                    onChanged: (value) => ref.read(validateFormUpdateProductNotifier.notifier).validateFieldPrice(value),
                    onEditingComplete: () => ref.read(validateFormUpdateProductNotifier.notifier).validateFieldPrice(_priceController.text.trim()),
                  ),
                  if (validateFormUpdateProductProvider.errorMessagePrice != null && validateFormUpdateProductProvider.errorMessagePrice!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        validateFormUpdateProductProvider.errorMessagePrice ?? "",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Description",
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
                    onChanged: (value) => ref.read(validateFormUpdateProductNotifier.notifier).validateFieldDescription(value),
                    onEditingComplete: () =>
                        ref.read(validateFormUpdateProductNotifier.notifier).validateFieldDescription(_descriptionController.text.trim()),
                  ),
                  if (validateFormUpdateProductProvider.errorMessageDescription != null &&
                      validateFormUpdateProductProvider.errorMessageDescription!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        validateFormUpdateProductProvider.errorMessageDescription ?? "",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (!ref.watch(isShowLoadingUpdateProductProvider)) {
                            FocusScope.of(context).unfocus();
                            ProductModel product = ProductModel(
                              id: widget.product!.id,
                              title: _titleController.text.trim(),
                              price: _priceController.text.trim().isNotEmpty ? int.parse(_priceController.text.trim()) : -1,
                              description: _descriptionController.text.trim(),
                              images: widget.product!.images,
                              creationAt: widget.product!.creationAt,
                              updatedAt: widget.product!.updatedAt,
                              category: widget.product!.category,
                            );
                            if (ref.read(validateFormUpdateProductNotifier.notifier).submitFormUpdateProduct(product)) {
                              ref.read(productsNotifier.notifier).updateProduct(product);
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 24),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ref.watch(isShowLoadingUpdateProductProvider)
                              ? const SpinKitCircle(color: Colors.white, size: 18)
                              : const Text(
                                  "Update",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
