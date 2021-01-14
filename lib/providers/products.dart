import 'package:flutter/Material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  
  final List<Product> _items = DUMMY_PRODUCTS;
  
  List<Product> get item => [..._items];  
  
  List<Product> get favoriteitem{
    return _items.where((prod) => prod.isFavorite).toList();
  }

  void addProduct(Product product){
    _items.add(product);
    notifyListeners();
  }
}