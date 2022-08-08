import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/presentation/page/chat/cubit/chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
}
