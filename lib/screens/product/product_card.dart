import 'package:flutter/material.dart';
import 'package:product_app/core/extension/theme_extension.dart';
import 'package:product_app/data/model/products_response/products_response.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.topology.textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _ProductImage(url: product.thumbnail)),
          Padding(
            padding: context.spacing.paddingS,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
                context.vXs,
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: textTheme.titleMedium?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
                context.vXs,
                _Rating(value: product.rating),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) {
      return const _ImagePlaceholder();
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const _ImagePlaceholder(isLoading: true),
      errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Center(
        child: isLoading
            ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.image_not_supported_outlined,
                size: 40,
                color: scheme.outline,
              ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
        context.hXs,
        Text(
          value.toStringAsFixed(1),
          style: context.topology.textTheme.bodySmall,
        ),
      ],
    );
  }
}
