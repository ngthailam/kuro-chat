import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/presentation/page/account/account_controller.dart';
import 'package:kuro_chat/presentation/widget/custom_circle_avatar.dart';

class AccountDrawer extends StatefulWidget {
  const AccountDrawer({Key? key}) : super(key: key);

  @override
  State<AccountDrawer> createState() => _AccountDrawerState();
}

class _AccountDrawerState extends State<AccountDrawer> {
  @override
  void initState() {
    super.initState();
    Get.put(AccountController(), tag: 'AccountController');
  }

  @override
  void dispose() {
    Get.delete(tag: 'AccountController');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(
                  children: [
                    CustomCircleAvatar(
                      name: currentUser!.name,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser!.id,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentUser!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ]),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: const Text('Log out'),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Get.find<AccountController>(tag: 'AccountController')
                        .logout();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
