import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/presentation/page/chat/cubit/chat_cubit.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatCubit _cubit = getIt();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCubit>(
      create: (_) => _cubit,
      child: Container(),
    );
  }
}
