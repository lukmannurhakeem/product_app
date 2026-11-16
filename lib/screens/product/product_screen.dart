import 'package:flutter/material.dart';
import 'package:product_app/core/extension/theme_extension.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/l10n/app_localizations.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/screens/product/product_card.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.productsTitle)),
      body: const SafeArea(child: _ProductBody()),
    );
  }
}

class _ProductBody extends StatelessWidget {
  const _ProductBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final products = provider.products;

    if (provider.isLoading && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.hasError && products.isEmpty) {
      return _ErrorView(onRetry: provider.fetchProducts);
    }
    if (products.isEmpty) {
      return const _EmptyView();
    }
    return _ProductGrid(products: products, onRefresh: provider.fetchProducts);
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products, required this.onRefresh});

  final List<Product> products;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        padding: context.spacing.paddingS,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(product: products[index]),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(AppLocalizations.of(context).productsEmpty));
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: context.spacing.paddingS,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.errorUnknown,
              textAlign: TextAlign.center,
              style: context.topology.textTheme.bodyMedium,
            ),
            context.vXs,
            FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
