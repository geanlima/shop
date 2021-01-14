import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  CartItemWidget(this.cartItem);

  final f = new NumberFormat("#,##0.00", "PT-br");

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('${cartItem.price}'),
              ),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text(
              'Total: R\$: ${f.format(cartItem.price * cartItem.quantity)}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
