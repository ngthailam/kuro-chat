import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/presentation/page/channel/list/cubit/channel_list_cubit.dart';
import 'package:kuro_chat/presentation/page/channel/list/cubit/channel_list_state.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({Key? key}) : super(key: key);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  final ChannelListCubit _cubit = getIt();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChannelListCubit>(
      create: (_) => _cubit,
      child: Stack(
        children: [
          _channelList([]),
          _createChannelFab(),
        ],
      ),
    );
  }

  Widget _channelList(List<ChannelEntity> channels) {
    return BlocBuilder<ChannelListCubit, ChannelListState>(
      buildWhen: (previous, current) {
        if (current is! ChannelListPrimary) {
          return false;
        }

        if (previous is ChannelListPrimary) {
          return previous.channels != current.channels;
        }

        return true;
      },
      builder: (context, state) {
        if (state is ChannelListPrimary && state.channels != null) {
          final channels = state.channels;

          if (channels!.isEmpty) {
            return const Text('You have no channels');
          }

          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, i) {
              return Text(channels[i].channelName);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _createChannelFab() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          _openCreateChannelPage();
        },
      ),
    );
  }

  void _openCreateChannelPage() {
    // TODO: impl
  }
}
