import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/core/errors/app_exception.dart';
import 'package:product_app/core/extension/theme_extension.dart';
import 'package:product_app/data/model/products_response/products_response.dart';
import 'package:product_app/l10n/app_localizations.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/screens/product/product_card.dart';
import 'package:provider/provider.dart';

import '../../core/errors/app_exception_l10n.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<ProductProvider>();
      provider.resetSearch();
      provider.fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    context.read<ProductProvider>().onSearchChanged(value);
  }

  void _onClear() {
    _searchController.clear();
    _onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.productsTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: context.spacing.paddingS,
              child: TextField(
                controller: _searchController,
                onChanged: _onChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _onClear,
                  ),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const Expanded(child: _ProductBody()),
          ],
        ),
      ),
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
      return _ErrorView(error: provider.error!, onRetry: provider.fetchProducts);
    }
    if (products.isEmpty) {
      return _EmptyView(isSearch: provider.query.isNotEmpty);
    }
    return Column(
      children: [
        if (provider.isOffline) const _OfflineNotice(),
        Expanded(
          child: _ProductGrid(
            products: products,
            isLoadingMore: provider.isLoadingMore,
            hasMore: provider.hasMore,
            onRefresh: provider.fetchProducts,
            onLoadMore: provider.loadMore,
          ),
        ),
      ],
    );
  }
}

class _OfflineNotice extends StatelessWidget {
  const _OfflineNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: scheme.errorContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.wifi_off, size: 18, color: scheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.errorNetwork,
              style: context.topology.textTheme.bodySmall?.copyWith(
                color: scheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    (context, index) => ProductCard(product: widget.products[index]),
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
  const _EmptyView({required this.isSearch});

  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Text(isSearch ? l10n.productsNoResults : l10n.productsEmpty),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final AppException error;
  final Future<void> Function() onRetry;

  bool get _isOffline =>
      error is NetworkException && error.code == AppErrorCode.network;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: context.spacing.paddingS,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isOffline)
              Lottie.asset(
                'assets/lottie/no_internet.lottie',
                width: 220,
                height: 220,
                repeat: true,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.wifi_off, size: 96),
              ),
            context.vM,
            Text(
              error.localized(l10n),
              textAlign: TextAlign.center,
              style: context.topology.textTheme.titleMedium,
            ),
            if (_isOffline)
              Text(
                l10n.errorNetworkDescription,
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