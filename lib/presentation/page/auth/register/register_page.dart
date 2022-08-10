import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/presentation/page/auth/register/register_controller.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterController _controller;

  final TextEditingController _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      _listenEvents();
    });
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _listenEvents() {
    _controller.registerLoadState.listen((state) {
      if (state == LoadState.success) {
        _openLoginPage();
        return;
      }

      if (state == LoadState.error) {
        Get.snackbar('', 'Register fail');
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller = Get.find<RegisterController>();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _textCtrl,
          ),
          const SizedBox(height: 8),
          MaterialButton(
            onPressed: () {
              if (_textCtrl.text.isEmpty) {
                Get.snackbar('', 'Name must not be empty');
                return;
              }
              _controller.registerUser(_textCtrl.text);
            },
            child: const Text('Register'),
          )
        ],
      ),
    );
  }

  void _openLoginPage() {
    Get.offAndToNamed(AppRouter.login);
  }
}
