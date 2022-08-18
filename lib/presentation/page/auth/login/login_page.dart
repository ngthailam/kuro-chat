import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/presentation/page/auth/login/login_controller.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController? _controller;

  final TextEditingController _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _listenEvents();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _listenEvents() {
    _controller?.loginLoadState.listen((state) {
      if (state == LoadState.success) {
        _openChannelListPage();
        return;
      }

      if (state == LoadState.error) {
        Get.snackbar('', 'Login fail');
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller ??= Get.find<LoginController>();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _textCtrl,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRouter.register);
            },
            child: const Text('Register'),
          ),
          MaterialButton(
            onPressed: () {
              if (_textCtrl.text.isEmpty) {
                Get.snackbar('', 'Name must not be empty');
                return;
              }
              _controller?.login(_textCtrl.text);
            },
            child: const Text('Login'),
          )
        ],
      ),
    );
  }

  void _openChannelListPage() {
    Get.offAndToNamed(AppRouter.channelList);
  }
}
