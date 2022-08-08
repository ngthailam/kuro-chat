import 'package:flutter/material.dart';
import 'package:kuro_chat/presentation/page/auth/login/login_page.dart';
import 'package:kuro_chat/presentation/page/auth/register/register_page.dart';
import 'package:kuro_chat/presentation/page/channel/create/channel_create_page.dart';
import 'package:kuro_chat/presentation/page/channel/list/channel_list_page.dart';
import 'package:kuro_chat/presentation/page/chat/chat_page.dart';
import 'package:kuro_chat/presentation/page/home/home_page.dart';

class AppRouter {
  static const String home = 'home';
  static const String register = 'register';
  static const String login = 'login';
  static const String channelList = 'channel/list';
  static const String channelCreate = 'channel/create';
  static const String chat = 'chat';

  static generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute(
          builder: (context) => const RegisterPage(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
          settings: settings,
        );
      case channelList:
        return MaterialPageRoute(
            builder: (context) => const ChannelListPage(), settings: settings);
      case channelCreate:
        return MaterialPageRoute(
            builder: (context) => const ChannelCreatePage(),
            settings: settings);
      case chat:
        return MaterialPageRoute(
            builder: (context) => const ChatPage(), settings: settings);
      default:
        return const Text('Not a valid route');
    }
  }
}
