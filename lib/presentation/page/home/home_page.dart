import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/presentation/page/home/cubit/home_cubit.dart';
import 'package:kuro_chat/presentation/page/home/cubit/home_state.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeCubit _cubit = getIt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _cubit..initialze(),
        child: BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) {
            if (current is HomeLoggedIn || current is HomeNotLoggedIn) {
              return previous != current;
            }

            return true;
          },
          listener: (context, state) {
            if (state is HomeLoggedIn) {
              Navigator.of(context).pushNamed(AppRouter.channelList);
              return;
            }

            if (state is HomeNotLoggedIn) {
              Navigator.of(context).pushNamed(AppRouter.login);
              return;
            }
          },
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
