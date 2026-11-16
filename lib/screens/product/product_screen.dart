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
    return _ProductGrid(
      products: products,
      isLoadingMore: provider.isLoadingMore,
      hasMore: provider.hasMore,
      onRefresh: provider.fetchProducts,
      onLoadMore: provider.loadMore,
    );
  }
}

class _ProductGrid extends StatefulWidget {
  const _ProductGrid({
    required this.products,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onRefresh,
    required this.onLoadMore,
  });

  final List<Product> products;
  final bool isLoadingMore;
  final bool hasMore;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;

  @override
  State<_ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<_ProductGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: context.spacing.paddingS,
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    ProductCard(product: widget.products[index]),
                childCount: widget.products.length,
              ),
            ),
          ),
          if (widget.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (!widget.hasMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: Text(l10n.productsEnd)),
              ),
            ),
        ],
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