import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/channel/repository/channel_repository.dart';
import 'package:kuro_chat/presentation/page/channel/list/cubit/channel_list_state.dart';

@injectable
class ChannelListCubit extends Cubit<ChannelListState> {
  ChannelListCubit(this._channelRepo) : super(ChannelListInitial());

  final ChannelRepo _channelRepo;

  initialize() async {
    final channels = await _channelRepo.getMyChannels();
    emit(ChannelListPrimary(channels: channels));
  }
}
