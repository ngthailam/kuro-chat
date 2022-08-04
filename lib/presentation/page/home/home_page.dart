import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/presentation/page/home/cubit/home_cubit.dart';
import 'package:kuro_chat/presentation/page/home/cubit/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeCubit _cubit = getIt();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        child: const SizedBox.shrink(),
      ),
    );
  }
}
