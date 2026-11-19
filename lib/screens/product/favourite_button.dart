import 'package:flutter/material.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/provider/favourite_provider.dart';
import 'package:provider/provider.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({super.key, required this.product, this.filled = false});

  final Product product;

  /// Adds a translucent background so it stays visible over images.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final isFavourite = context.select<FavouriteProvider, bool>(
          (p) => p.isFavourite(product.id),
    );
    final scheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: () => context.read<FavouriteProvider>().toggle(product),
      icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border),
      color: isFavourite ? Colors.red : null,
      style: filled
          ? IconButton.styleFrom(
        backgroundColor: scheme.surface.withValues(alpha: 0.7),
      )
          : null,
    );
  }
}