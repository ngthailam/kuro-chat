import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/channel/repository/channel_repository.dart';
import 'package:kuro_chat/presentation/page/channel/create/cubit/channel_create_state.dart';

@injectable
class ChannelCreateCubit extends Cubit<ChannelCreateState> {
  ChannelCreateCubit(this._channelRepo) : super(ChannelCreateInitial());

  final ChannelRepo _channelRepo;

  findChannel(String channelId) async {
    final channels = await _channelRepo.findChannel(channelId);
  }

  createChannel(String receiverId) async {
    await _channelRepo.createChannel(receiverId);
  }
}
