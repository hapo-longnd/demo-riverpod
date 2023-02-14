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
        return AsyncError("Something went wrong, Please try again!", StackTrace.current);
      }
    } catch (e) {
      return AsyncError("Something went wrong, Please try again!", StackTrace.current);
    }
  }

  Future<AsyncValue<String>> updateProduct(ProductModel product) async {
    try {
      final response = await Dio().put("https://api.escuelajs.co/api/v1/products/${product.id}" , data: product.toJson());
      if ((response.statusCode! - 200) < 100) {
        return const AsyncData("Update product success");
      } else {
        return AsyncError("Update product fail", StackTrace.current);
      }
    } catch (e) {
      return AsyncError("Something went wrong, Please try again!", StackTrace.current);
    }
  }

  Future<AsyncValue<String>> deleteProduct(int productId) async {
    try {
      final response = await Dio().delete("https://api.escuelajs.co/api/v1/products/$productId");
      if ((response.statusCode! - 200) < 100) {
        return const AsyncData("Delete product success");
      } else {
        return AsyncError("Delete product fail", StackTrace.current);
      }
    } catch (e) {
      return AsyncError("Something went wrong, Please try again!", StackTrace.current);
    }
  }
}
