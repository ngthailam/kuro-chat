import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/presentation/page/channel/list/cubit/channel_list_state.dart';

@injectable
class ChannelListCubit extends Cubit<ChannelListState> {
  ChannelListCubit() : super(ChannelListInitial());
}
