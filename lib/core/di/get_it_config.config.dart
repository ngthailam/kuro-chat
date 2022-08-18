// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/auth/datasource/auth_remote_datasource.dart' as _i13;
import '../../data/auth/repo/auth_repository.dart' as _i14;
import '../../data/channel/datasource/channel_local_datasource.dart' as _i3;
import '../../data/channel/datasource/channel_remote_datasource.dart' as _i15;
import '../../data/channel/repository/channel_repository.dart' as _i16;
import '../../data/chat/datasource/chat_local_datasource.dart' as _i4;
import '../../data/chat/datasource/chat_remote_datasource.dart' as _i5;
import '../../data/chat/repository/chat_repo.dart' as _i17;
import '../../data/lastmessage/datasource/last_message_local_datasource.dart'
    as _i6;
import '../../data/lastmessage/datasource/last_message_remote_datasource.dart'
    as _i7;
import '../../data/lastmessage/repo/last_message_repo.dart' as _i8;
import '../../data/meta_data/repository/meta_data_repo.dart' as _i9;
import '../../data/user/datasource/user_local_datasource.dart' as _i10;
import '../../data/user/datasource/user_remote_datasource.dart' as _i11;
import '../../data/user/repo/user_repository.dart'
    as _i12; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.ChannelLocalDataSource>(
      () => _i3.ChannelLocalDataSourceImpl());
  gh.factory<_i4.ChatLocalDataSource>(() => _i4.ChatLocalDataSourceImpl());
  gh.factory<_i5.ChatRemoteDataSource>(() => _i5.ChatRemoteDataSourceImpl());
  gh.factory<_i6.LastMessageLocalDataSource>(
      () => _i6.LastMessageLocalDataSourceImpl());
  gh.factory<_i7.LastMessageRemoteDataSource>(
      () => _i7.LastMessageRemoteDataSourceImpl());
  gh.factory<_i8.LastMessageRepo>(() => _i8.LastMessageRepoImpl(
      get<_i6.LastMessageLocalDataSource>(),
      get<_i7.LastMessageRemoteDataSource>()));
  gh.factory<_i9.MetaDataRepo>(() => _i9.MetaDataRepoImpl());
  gh.factory<_i10.UserLocalDataSource>(() => _i10.UserLocalDataSourceImpl());
  gh.factory<_i11.UserRemoteDataSource>(() => _i11.UserRemoteDataSourceImpl());
  gh.factory<_i12.UserRepo>(() => _i12.UserRepoImpl(
      get<_i10.UserLocalDataSource>(), get<_i11.UserRemoteDataSource>()));
  gh.factory<_i13.AuthRemoteDataSource>(
      () => _i13.AuthRemoteDataSourceImpl(get<_i11.UserRemoteDataSource>()));
  gh.factory<_i14.AuthRepo>(() => _i14.AuthRepoImpl(
      get<_i13.AuthRemoteDataSource>(),
      get<_i11.UserRemoteDataSource>(),
      get<_i10.UserLocalDataSource>(),
      get<_i6.LastMessageLocalDataSource>()));
  gh.factory<_i15.ChannelRemoteDataSource>(
      () => _i15.ChannelRemoteDataSourceImpl(get<_i5.ChatRemoteDataSource>()));
  gh.factory<_i16.ChannelRepo>(() => _i16.ChannelRepoImpl(
      get<_i3.ChannelLocalDataSource>(), get<_i15.ChannelRemoteDataSource>()));
  gh.factory<_i17.ChatRepo>(() => _i17.ChatRepoImpl(
      get<_i4.ChatLocalDataSource>(),
      get<_i5.ChatRemoteDataSource>(),
      get<_i7.LastMessageRemoteDataSource>()));
  return get;
}
