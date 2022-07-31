// This is our global ServiceLocator
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/core/di/get_it_config.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void initGetItDi() => $initGetIt(getIt);