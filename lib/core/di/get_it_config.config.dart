// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/auth/datasource/auth_remote_datasource.dart' as _i3;
import '../../data/auth/repo/auth_repository.dart' as _i12;
import '../../data/channel/datasource/channel_local_datasource.dart' as _i6;
import '../../data/channel/datasource/channel_remote_datasource.dart' as _i18;
import '../../data/channel/repository/channel_repository.dart' as _i19;
import '../../data/chat/datasource/chat_local_datasource.dart' as _i8;
import '../../data/chat/datasource/chat_remote_datasource.dart' as _i13;
import '../../data/chat/repository/chat_repo.dart' as _i14;
import '../../data/user/datasource/user_local_datasource.dart' as _i9;
import '../../data/user/datasource/user_remote_datasource.dart' as _i10;
import '../../data/user/repo/user_repository.dart' as _i11;
import '../../presentation/page/auth/login/cubit/login_cubit.dart' as _i16;
import '../../presentation/page/auth/register/cubit/register_cubit.dart'
    as _i17;
import '../../presentation/page/channel/create/cubit/channel_create_cubit.dart'
    as _i4;
import '../../presentation/page/channel/list/cubit/channel_list_cubit.dart'
    as _i5;
import '../../presentation/page/chat/cubit/chat_cubit.dart' as _i7;
import '../../presentation/page/home/cubit/home_cubit.dart'
    as _i15; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.AuthRemoteDataSource>(() => _i3.AuthRemoteDataSourceImpl());
  gh.factory<_i4.ChannelCreateCubit>(() => _i4.ChannelCreateCubit());
  gh.factory<_i5.ChannelListCubit>(() => _i5.ChannelListCubit());
  gh.factory<_i6.ChannelLocalDataSource>(
      () => _i6.ChannelLocalDataSourceImpl());
  gh.factory<_i7.ChatCubit>(() => _i7.ChatCubit());
  gh.factory<_i8.ChatLocalDataSource>(() => _i8.ChatLocalDataSourceImpl());
  gh.factory<_i9.UserLocalDataSource>(() => _i9.UserLocalDataSourceImpl());
  gh.factory<_i10.UserRemoteDataSource>(() => _i10.UserRemoteDataSourceImpl());
  gh.factory<_i11.UserRepo>(() => _i11.UserRepoImpl(
      get<_i9.UserLocalDataSource>(), get<_i10.UserRemoteDataSource>()));
  gh.factory<_i12.AuthRepo>(() => _i12.AuthRepoImpl(
      get<_i3.AuthRemoteDataSource>(),
      get<_i10.UserRemoteDataSource>(),
      get<_i9.UserLocalDataSource>()));
  gh.factory<_i13.ChatRemoteDataSource>(
      () => _i13.ChatRemoteDataSourceImpl(get<_i9.UserLocalDataSource>()));
  gh.factory<_i14.ChatRepo>(() => _i14.ChatRepoImpl(
      get<_i8.ChatLocalDataSource>(), get<_i13.ChatRemoteDataSource>()));
  gh.factory<_i15.HomeCubit>(() => _i15.HomeCubit(get<_i12.AuthRepo>()));
  gh.factory<_i16.LoginCubit>(() => _i16.LoginCubit(get<_i12.AuthRepo>()));
  gh.factory<_i17.RegisterCubit>(
      () => _i17.RegisterCubit(get<_i12.AuthRepo>()));
  gh.factory<_i18.ChannelRemoteDataSource>(() =>
      _i18.ChannelRemoteDataSourceImpl(
          get<_i9.UserLocalDataSource>(), get<_i13.ChatRemoteDataSource>()));
  gh.factory<_i19.ChannelRepo>(() => _i19.ChannelRepoImpl(
      get<_i6.ChannelLocalDataSource>(), get<_i18.ChannelRemoteDataSource>()));
  return get;
}
