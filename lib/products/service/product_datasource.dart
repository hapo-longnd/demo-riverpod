import 'dart:convert';

import 'package:demo_riverpod/products/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDataSource {
  Future<AsyncValue<List<ProductModel>>> fetchProduct({int? limit, int? offset}) async {
    try {
      List<ProductModel> listProduct = [];
      final response = await Dio().get("https://api.escuelajs.co/api/v1/products?limit=${limit ?? 100}&offset=${offset ?? 1}");
      if ((response.statusCode! - 200) < 100) {
        if ((response.data as List).isNotEmpty) {
          for (var element in response.data) {
            listProduct.add(ProductModel.fromJson(element));
          }
        }
        return AsyncData(listProduct);
      } else {
        return AsyncError("Đã có lỗi xảy ra, Vui lòng thử lại!", StackTrace.current);
      }
    } catch (e) {
      return AsyncError("Đã có lỗi xảy ra, Vui lòng thử lại!", StackTrace.current);
    }
  }
}
