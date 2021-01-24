import 'dart:convert';
import 'package:flutter/Material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';

import 'package:shop/providers/product.dart';
import 'package:shop/utils/constants.dart';

class Products with ChangeNotifier {
  final String _baseUrl =
      '${Constants.BASE_API_URL}/products';
  final List<Product> _items = []; //DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  List<Product> get favoriteitem {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();

    if (data != null) {
      data.forEach(
        (productId, productData) {
          _items.add(
            Product(
              id: productId,
              title: productData['title'],
              price: productData['price'],
              description: productData['description'],
              imageUrl: productData['imageUrl'],
              isFavorite: productData['isFavorite'],
            ),
          );
        },
      );
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      "$_baseUrl.json",
      body: json.encode({
        "title": newProduct.title,
        "price": newProduct.price,
        "description": newProduct.description,
        "imageUrl": newProduct.imageUrl,
        "isFavorite": newProduct.isFavorite,
      }),
    );
    _items.add(
      Product(
        id: json.decode(response.body)['name'],
        title: newProduct.title,
        price: newProduct.price,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product != null && product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      await http.patch(
        "$_baseUrl/${product.id}.json",
        body: json.encode({
          "title": product.title,
          "price": product.price,
          "description": product.description,
          "imageUrl": product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == prod.id);

    if (index >= 0) {
      final product = _items[index];
       _items.remove(product);
       notifyListeners();

      final response = await http.delete("$_baseUrl/${product.id}.json");
      
      if(response.statusCode >= 400){
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclussao do produto');
      }
      
      
    }
  }
}
