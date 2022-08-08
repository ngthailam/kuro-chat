import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/presentation/page/auth/login/cubit/login_cubit.dart';
import 'package:kuro_chat/presentation/page/auth/login/cubit/login_state.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginCubit _cubit = getIt();

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginCubit>(
        create: (_) => _cubit,
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginResult) {
              if (state.isSuccess) {
                _openChannelListPage();
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Error')));
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouter.register);
                },
                child: const Text('Register'),
              ),
              MaterialButton(
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    // TODO: show error
                    return;
                  }
                  _cubit.login(_controller.text);
                },
                child: Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openChannelListPage() {
    Navigator.of(context).popAndPushNamed(AppRouter.channelList);
  }
}
