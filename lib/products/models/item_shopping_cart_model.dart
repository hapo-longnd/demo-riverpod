import 'package:demo_riverpod/products/models/product_model.dart';

class ItemShoppingCartModel {
  int? quantity;
  ProductModel? product;

  ItemShoppingCartModel({this.quantity, this.product});

  ItemShoppingCartModel.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
