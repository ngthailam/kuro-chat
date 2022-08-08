import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/presentation/page/auth/register/cubit/register_cubit.dart';
import 'package:kuro_chat/presentation/page/auth/register/cubit/register_state.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterCubit _cubit = getIt();

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<RegisterCubit>(
        create: (_) => _cubit,
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              _openLoginPage();
              return;
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
              ),
              const SizedBox(height: 8),
              MaterialButton(
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    // TODO: show error
                    return;
                  }
                  _cubit.registerUser(_controller.text);
                },
                child: Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openLoginPage() {
    Navigator.of(context).popAndPushNamed(AppRouter.login);
  }
}
