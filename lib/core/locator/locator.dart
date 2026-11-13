import 'package:get_it/get_it.dart';
import 'package:product_app/core/local_storage/local_storage_service.dart';
import 'package:product_app/core/navigation/navigation_service.dart';
import 'package:product_app/core/network/api_client.dart';
import 'package:product_app/storage/theme_storage.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final storage = LocalStorageService();
  await storage.init();
  locator.registerSingleton<LocalStorageService>(storage);
  locator.registerLazySingleton<NavigationService>(NavigationService.new);
  locator.registerLazySingleton<ApiClient>(ApiClient.new);
  locator.registerLazySingleton<ThemeStorage>(
    () => ThemeStorage(locator<LocalStorageService>()),
  );
}
