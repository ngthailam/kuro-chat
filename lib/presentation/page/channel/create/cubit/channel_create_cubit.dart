import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/presentation/page/channel/create/cubit/channel_create_state.dart';

@injectable
class ChannelCreateCubit extends Cubit<ChannelCreateState> {
  ChannelCreateCubit() : super(ChannelCreateInitial());
}
