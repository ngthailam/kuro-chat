import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/presentation/page/channel/create/cubit/channel_create_cubit.dart';
import 'package:kuro_chat/presentation/page/channel/list/cubit/channel_list_cubit.dart';

class ChannelCreatePage extends StatefulWidget {
  const ChannelCreatePage({Key? key}) : super(key: key);

  @override
  State<ChannelCreatePage> createState() => _ChannelCreatePageState();
}

class _ChannelCreatePageState extends State<ChannelCreatePage> {
  final ChannelCreateCubit _cubit = getIt();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChannelCreateCubit>(
      create: (_) => _cubit,
      child: Stack(
        children: [
          // TODO: impl
        ],
      ),
    );
  }
}
