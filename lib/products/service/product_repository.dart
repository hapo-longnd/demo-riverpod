import 'package:demo_riverpod/products/models/product_model.dart';
import 'package:demo_riverpod/products/service/product_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ProductRepository {
  final ProductDataSource _productDataSource;

  ProductRepository(this._productDataSource);

  Future<AsyncValue<List<ProductModel>>> fetchProduct({int? limit, int? offset}) async {
    return await _productDataSource.fetchProduct(limit: limit, offset: offset);
  }
}
