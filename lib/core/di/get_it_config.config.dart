// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/auth/datasource/auth_remote_datasource.dart' as _i3;
import '../../data/auth/repo/auth_repository.dart' as _i10;
import '../../data/channel/datasource/channel_local_datasource.dart' as _i4;
import '../../data/channel/datasource/channel_remote_datasource.dart' as _i16;
import '../../data/channel/repository/channel_repository.dart' as _i17;
import '../../data/chat/datasource/chat_local_datasource.dart' as _i6;
import '../../data/chat/datasource/chat_remote_datasource.dart' as _i11;
import '../../data/chat/repository/chat_repo.dart' as _i12;
import '../../data/user/datasource/user_local_datasource.dart' as _i7;
import '../../data/user/datasource/user_remote_datasource.dart' as _i8;
import '../../data/user/repo/user_repository.dart' as _i9;
import '../../presentation/page/auth/login/cubit/login_cubit.dart' as _i14;
import '../../presentation/page/auth/register/cubit/register_cubit.dart'
    as _i15;
import '../../presentation/page/channel/create/cubit/channel_create_cubit.dart'
    as _i18;
import '../../presentation/page/channel/list/cubit/channel_list_cubit.dart'
    as _i19;
import '../../presentation/page/chat/cubit/chat_cubit.dart' as _i5;
import '../../presentation/page/home/cubit/home_cubit.dart'
    as _i13; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.AuthRemoteDataSource>(() => _i3.AuthRemoteDataSourceImpl());
  gh.factory<_i4.ChannelLocalDataSource>(
      () => _i4.ChannelLocalDataSourceImpl());
  gh.factory<_i5.ChatCubit>(() => _i5.ChatCubit());
  gh.factory<_i6.ChatLocalDataSource>(() => _i6.ChatLocalDataSourceImpl());
  gh.factory<_i7.UserLocalDataSource>(() => _i7.UserLocalDataSourceImpl());
  gh.factory<_i8.UserRemoteDataSource>(() => _i8.UserRemoteDataSourceImpl());
  gh.factory<_i9.UserRepo>(() => _i9.UserRepoImpl(
      get<_i7.UserLocalDataSource>(), get<_i8.UserRemoteDataSource>()));
  gh.factory<_i10.AuthRepo>(() => _i10.AuthRepoImpl(
      get<_i3.AuthRemoteDataSource>(),
      get<_i8.UserRemoteDataSource>(),
      get<_i7.UserLocalDataSource>()));
  gh.factory<_i11.ChatRemoteDataSource>(
      () => _i11.ChatRemoteDataSourceImpl(get<_i7.UserLocalDataSource>()));
  gh.factory<_i12.ChatRepo>(() => _i12.ChatRepoImpl(
      get<_i6.ChatLocalDataSource>(), get<_i11.ChatRemoteDataSource>()));
  gh.factory<_i13.HomeCubit>(() => _i13.HomeCubit(get<_i10.AuthRepo>()));
  gh.factory<_i14.LoginCubit>(() => _i14.LoginCubit(get<_i10.AuthRepo>()));
  gh.factory<_i15.RegisterCubit>(
      () => _i15.RegisterCubit(get<_i10.AuthRepo>()));
  gh.factory<_i16.ChannelRemoteDataSource>(() =>
      _i16.ChannelRemoteDataSourceImpl(
          get<_i7.UserLocalDataSource>(), get<_i11.ChatRemoteDataSource>()));
  gh.factory<_i17.ChannelRepo>(() => _i17.ChannelRepoImpl(
      get<_i4.ChannelLocalDataSource>(), get<_i16.ChannelRemoteDataSource>()));
  gh.factory<_i18.ChannelCreateCubit>(
      () => _i18.ChannelCreateCubit(get<_i17.ChannelRepo>()));
  gh.factory<_i19.ChannelListCubit>(
      () => _i19.ChannelListCubit(get<_i17.ChannelRepo>()));
  return get;
}
