import 'package:flutter/material.dart';
import 'package:product_app/core/extension/theme_extension.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/l10n/app_localizations.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, this.product});

  final Product? product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product? _resolveProduct(BuildContext context) {
    if (widget.product != null) return widget.product;
    final args = ModalRoute.of(context)?.settings.arguments;
    return args is Product ? args : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final product = _resolveProduct(context);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorUnknown)),
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final images = _imagesOf(product);

    return Scaffold(
      appBar: AppBar(title: Text(product.title ?? '')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageCarousel(images: images),
              Padding(
                padding: context.spacing.paddingS,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title ?? '', style: textTheme.titleLarge),
                    context.vS,
                    Text(
                      '\RM ${(product.price ?? 0).toStringAsFixed(2)}',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    context.vS,
                    _StockChip(stock: product.stock ?? 0),
                    context.vM,
                    Text(l10n.productDescription, style: textTheme.titleMedium),
                    context.vS,
                    Text(
                      product.description ?? '',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _imagesOf(Product product) {
    final list = <String>[...(product.images ?? const <String>[])];
    if (list.isEmpty && (product.thumbnail?.isNotEmpty ?? false)) {
      list.add(product.thumbnail!);
    }
    return list;
  }
}

class _ImageCarousel extends StatefulWidget {
  const _ImageCarousel({required this.images});

  final List<String> images;

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const AspectRatio(
        aspectRatio: 1,
        child: Center(child: Icon(Icons.image_not_supported, size: 64)),
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => Image.network(
              widget.images[i],
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : const Center(child: CircularProgressIndicator()),
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image, size: 64)),
            ),
          ),
          if (widget.images.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.images.length,
                  (i) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  const _StockChip({required this.stock});

  final int stock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inStock = stock > 0;
    final color = !inStock
        ? Colors.red
        : stock <= 5
        ? Colors.orange
        : Colors.green;

    return Chip(
      avatar: Icon(
        inStock ? Icons.check_circle : Icons.cancel,
        size: 18,
        color: color,
      ),
      label: Text(
        inStock ? l10n.productInStock(stock) : l10n.productOutOfStock,
      ),
      side: BorderSide(color: color),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}
