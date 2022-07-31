// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/auth/datasource/auth_remote_datasource.dart' as _i3;
import '../../data/auth/repo/auth_repository.dart' as _i7;
import '../../data/user/datasource/user_local_datasource.dart' as _i4;
import '../../data/user/datasource/user_remote_datasource.dart' as _i5;
import '../../data/user/repo/user_repository.dart'
    as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.AuthRemoteDataSource>(() => _i3.AuthRemoteDataSourceImpl());
  gh.factory<_i4.UserLocalDataSource>(() => _i4.UserLocalDataSourceImpl());
  gh.factory<_i5.UserRemoteDataSource>(() => _i5.UserRemoteDataSourceImpl());
  gh.factory<_i6.UserRepo>(() => _i6.UserRepoImpl(
      get<_i4.UserLocalDataSource>(), get<_i5.UserRemoteDataSource>()));
  gh.factory<_i7.AuthRepo>(() => _i7.AuthRepoImpl(
      get<_i3.AuthRemoteDataSource>(),
      get<_i5.UserRemoteDataSource>(),
      get<_i4.UserLocalDataSource>()));
  return get;
}
