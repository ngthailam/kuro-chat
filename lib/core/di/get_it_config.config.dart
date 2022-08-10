// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/auth/datasource/auth_remote_datasource.dart' as _i10;
import '../../data/auth/repo/auth_repository.dart' as _i11;
import '../../data/channel/datasource/channel_local_datasource.dart' as _i3;
import '../../data/channel/datasource/channel_remote_datasource.dart' as _i12;
import '../../data/channel/repository/channel_repository.dart' as _i13;
import '../../data/chat/datasource/chat_local_datasource.dart' as _i4;
import '../../data/chat/datasource/chat_remote_datasource.dart' as _i5;
import '../../data/chat/repository/chat_repo.dart' as _i6;
import '../../data/user/datasource/user_local_datasource.dart' as _i7;
import '../../data/user/datasource/user_remote_datasource.dart' as _i8;
import '../../data/user/repo/user_repository.dart'
    as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.ChannelLocalDataSource>(
      () => _i3.ChannelLocalDataSourceImpl());
  gh.factory<_i4.ChatLocalDataSource>(() => _i4.ChatLocalDataSourceImpl());
  gh.factory<_i5.ChatRemoteDataSource>(() => _i5.ChatRemoteDataSourceImpl());
  gh.factory<_i6.ChatRepo>(() => _i6.ChatRepoImpl(
      get<_i4.ChatLocalDataSource>(), get<_i5.ChatRemoteDataSource>()));
  gh.factory<_i7.UserLocalDataSource>(() => _i7.UserLocalDataSourceImpl());
  gh.factory<_i8.UserRemoteDataSource>(() => _i8.UserRemoteDataSourceImpl());
  gh.factory<_i9.UserRepo>(() => _i9.UserRepoImpl(
      get<_i7.UserLocalDataSource>(), get<_i8.UserRemoteDataSource>()));
  gh.factory<_i10.AuthRemoteDataSource>(
      () => _i10.AuthRemoteDataSourceImpl(get<_i8.UserRemoteDataSource>()));
  gh.factory<_i11.AuthRepo>(() => _i11.AuthRepoImpl(
      get<_i10.AuthRemoteDataSource>(),
      get<_i8.UserRemoteDataSource>(),
      get<_i7.UserLocalDataSource>()));
  gh.factory<_i12.ChannelRemoteDataSource>(() =>
      _i12.ChannelRemoteDataSourceImpl(get<_i5.ChatRemoteDataSource>()));
  gh.factory<_i13.ChannelRepo>(() => _i13.ChannelRepoImpl(
      get<_i3.ChannelLocalDataSource>(), get<_i12.ChannelRemoteDataSource>()));
  return get;
}
