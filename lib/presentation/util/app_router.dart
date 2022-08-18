import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kuro_chat/presentation/page/auth/login/login_controller.dart';
import 'package:kuro_chat/presentation/page/auth/login/login_page.dart';
import 'package:kuro_chat/presentation/page/auth/register/register_controller.dart';
import 'package:kuro_chat/presentation/page/auth/register/register_page.dart';
import 'package:kuro_chat/presentation/page/channel/create/channel_create_controller.dart';
import 'package:kuro_chat/presentation/page/channel/create/channel_create_page.dart';
import 'package:kuro_chat/presentation/page/channel/create/group/channel_create_group_controller.dart';
import 'package:kuro_chat/presentation/page/channel/create/group/channel_create_group_page.dart';
import 'package:kuro_chat/presentation/page/channel/list/channel_list_controller.dart';
import 'package:kuro_chat/presentation/page/channel/list/channel_list_page.dart';
import 'package:kuro_chat/presentation/page/chat/chat_controller.dart';
import 'package:kuro_chat/presentation/page/chat/chat_page.dart';
import 'package:kuro_chat/presentation/page/home/home_controller.dart';
import 'package:kuro_chat/presentation/page/home/home_page.dart';

class AppRouter {
  static const String home = '/home';
  static const String register = '/register';
  static const String login = '/login';
  static const String channelList = '/channel/list';
  static const String channelCreate = '/channel/create';
  static const String channelCreateGroup = '/channel/create/group';
  static const String chat = '/chat';

  static getNavigationPages() {
    return [
      GetPage(
        name: AppRouter.home,
        page: () => const HomePage(),
        binding: HomeBindings(),
      ),
      GetPage(
        name: AppRouter.login,
        page: () => const LoginPage(),
        binding: LoginBindings(),
      ),
      GetPage(
        name: AppRouter.register,
        page: () => const RegisterPage(),
        binding: RegisterBindings(),
      ),
      GetPage(
        name: AppRouter.channelList,
        page: () => const ChannelListPage(),
        binding: ChannelListBindings(),
      ),
      GetPage(
        name: AppRouter.channelCreate,
        page: () => const ChannelCreatePage(),
        binding: ChannelCreateBindings(),
      ),
      GetPage(
        name: AppRouter.chat,
        page: () => const ChatPage(),
        binding: ChatBindings(),
      ),
      GetPage(
        name: AppRouter.channelCreateGroup,
        page: () => const ChannelCreateGroupPage(),
        binding: ChannelCreateGroupBindings(),
      ),
    ];
  }
}
