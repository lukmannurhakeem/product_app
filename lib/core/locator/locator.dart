import 'package:get_it/get_it.dart';
import 'package:product_app/core/local_storage/local_storage_service.dart';
import 'package:product_app/core/navigation/navigation_service.dart';
import 'package:product_app/core/network/api_client.dart';
import 'package:product_app/data/impl/products_impl.dart';
import 'package:product_app/data/repositories/product_repository.dart';
import 'package:product_app/provider/favourite_provider.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/storage/favourite_storage.dart';
import 'package:product_app/storage/product_storage.dart';
import 'package:product_app/storage/theme_storage.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  final storage = LocalStorageService();
  await storage.init();
  locator.registerSingleton<LocalStorageService>(storage);
  locator.registerLazySingleton<NavigationService>(NavigationService.new);
  locator.registerLazySingleton<ApiClient>(ApiClient.new);

  // Storage
  locator.registerLazySingleton<ThemeStorage>(
        () => ThemeStorage(locator<LocalStorageService>()),
  );
  locator.registerLazySingleton<ProductStorage>(
        () => ProductStorage(locator<LocalStorageService>()),
  );
  locator.registerLazySingleton<FavouriteStorage>(
        () => FavouriteStorage(locator<LocalStorageService>()),
  );

  // Repositories
  locator.registerLazySingleton<ProductRepository>(
        () => ProductsImpl(locator<ApiClient>(), locator<ProductStorage>()),
  );

  // Providers
  locator.registerLazySingleton<ProductProvider>(
        () => ProductProvider(locator<ProductRepository>()),
  );
  locator.registerLazySingleton<FavouriteProvider>(
        () => FavouriteProvider(locator<FavouriteStorage>()),
  );
}