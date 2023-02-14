import 'package:demo_riverpod/products/models/product_model.dart';
import 'package:demo_riverpod/products/models/validate_form_update_product_model.dart';
import 'package:demo_riverpod/products/providers/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final validateFormUpdateProductNotifier =
    StateNotifierProvider.autoDispose<ValidateFormUpdateProductsNotifier, ValidateFormUpdateProductModel>((ref) {
  return ValidateFormUpdateProductsNotifier();
});

class ValidateFormUpdateProductsNotifier extends StateNotifier<ValidateFormUpdateProductModel> {
  ValidateFormUpdateProductsNotifier() : super(ValidateFormUpdateProductModel());

  void validateFieldTitle(String title) {
    if (title.trim() == "") {
      state = state.copyWith(errorMessageTitle: "This field is required to enter");
    } else {
      state = state.copyWith(errorMessageTitle: "");
    }
  }

  void validateFieldPrice(String price) {
    if (price.trim() == "" || price.trim() == "-1") {
      state = state.copyWith(errorMessagePrice: "This field is required to enter");
    } else {
      state = state.copyWith(errorMessagePrice: "");
    }
  }

  void validateFieldDescription(String description) {
    if (description.trim() == "") {
      state = state.copyWith(errorMessageDescription: "This field is required to enter");
    } else {
      state = state.copyWith(errorMessageDescription: "");
    }
  }

  bool submitFormUpdateProduct(ProductModel dataForm) {
    validateFieldTitle(dataForm.title ?? "");
    validateFieldPrice(dataForm.price != null ? dataForm.price.toString() : "");
    validateFieldDescription(dataForm.description ?? "");
    if (state.errorMessageTitle!.isNotEmpty || state.errorMessagePrice!.isNotEmpty || state.errorMessageDescription!.isNotEmpty) {
      return false;
    }
    return true;
  }
}

final fetchDetailProductProvider = FutureProvider.autoDispose.family<ProductModel, int>((ref, productId) async {
  ref.read(errorMessageFetchProductDetailProvider.notifier).update((state) => "");
  return await ref.watch(productRepository).fetchProductDetail(productId).then((value) {
    if (value.hasValue) {
      return value.asData!.value;
    } else {
      ref.read(errorMessageFetchProductDetailProvider.notifier).update((state) => value.asError!.error.toString());
      return ProductModel();
    }
  });
});

final errorMessageFetchProductDetailProvider = StateProvider.autoDispose((ref) => "");
