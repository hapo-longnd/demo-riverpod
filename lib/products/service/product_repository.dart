import 'package:demo_riverpod/products/models/category_model.dart';
import 'package:demo_riverpod/products/models/product_model.dart';
import 'package:demo_riverpod/products/service/product_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRepository {
  final ProductDataSource _productDataSource;

  ProductRepository(this._productDataSource);

  Future<AsyncValue<List<ProductModel>>> fetchProduct({int? limit, int? offset}) async {
    return await _productDataSource.fetchProduct(limit: limit, offset: offset);
  }

  Future<AsyncValue<List<CategoryModel>>> fetchListCategory({int? limit}) async {
    return await _productDataSource.fetchListCategory(limit: limit);
  }

  Future<AsyncValue<ProductModel>> fetchProductDetail(int productId) async {
    return await _productDataSource.fetchProductDetail(productId);
  }

  Future<AsyncValue<String>> updateProduct(ProductModel product) async {
    return await _productDataSource.updateProduct(product);
  }

  Future<AsyncValue<String>> deleteProduct(int productId) async {
    return await _productDataSource.deleteProduct(productId);
  }
}
