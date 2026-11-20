import 'package:flutter/material.dart';
import 'package:product_app/core/extension/theme_extension.dart';
import 'package:product_app/l10n/app_localizations.dart';
import 'package:product_app/provider/favourite_provider.dart';
import 'package:product_app/screens/product/product_card.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = context.watch<FavouriteProvider>().items;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wishlistTitle)),
      body: SafeArea(
        child: items.isEmpty
            ? const _EmptyView()
            : GridView.builder(
          padding: context.spacing.paddingS,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.68,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => ProductCard(
            key: ValueKey(items[index].id),
            product: items[index],
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 72, color: scheme.outline),
          context.vS,
          Text(
            l10n.wishlistEmpty,
            style: context.topology.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}