import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/presentation/page/channel/create/cubit/channel_create_cubit.dart';

class ChannelCreatePage extends StatefulWidget {
  const ChannelCreatePage({Key? key}) : super(key: key);

  @override
  State<ChannelCreatePage> createState() => _ChannelCreatePageState();
}

class _ChannelCreatePageState extends State<ChannelCreatePage> {
  final ChannelCreateCubit _cubit = getIt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ChannelCreateCubit>(
        create: (_) => _cubit,
        child: Text(
          'Create channel poage',
        ),
      ),
    );
  }
}
