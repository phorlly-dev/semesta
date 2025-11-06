import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:semesta/app/utils/format.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/ui/partials/_layout.dart';
import 'package:semesta/ui/widgets/custom_clipboard.dart';
import 'package:semesta/ui/widgets/custom_image.dart';
import 'package:semesta/ui/widgets/loading.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    final date = DateTime(2025, 11, 6, 13, 2);

    return Layout(
      content: Center(
        child: Obx(() {
          final user = auth.item.value;

          return auth.isLoggedIn
              ? Container(
                  margin: EdgeInsets.only(top: 32.h),
                  child: Column(
                    spacing: 8,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        child: user?.photoURL != null
                            ? CustomImage(imageUrl: user?.photoURL ?? '')
                            : CustomImage(imageUrl: setImage('man.png')),
                      ),
                      Text(user?.email ?? ''),
                      Text(user?.displayName == null ? '' : 'Anonymous User'),
                      CustomClipboard(data: user!.uid, message: 'UID'),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: auth.logout,
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Sign Out'),
                      ),

                      Text(timeAgo(date)),
                    ],
                  ),
                )
              : Loading(title: 'Not logged in');
        }),
      ),
    );
  }
}
