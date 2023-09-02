import 'package:flutter/material.dart';
import 'package:thesis_client/controller/login_controller.dart';
import 'package:thesis_client/controller/utility.dart';
import 'package:thesis_client/widgets/title_text.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  // void loginButtonPressed() async {
  //   try {
  //     await LoginController().login();
  //     // Utility.showSnackBar(context, 'Logged');
  //     // Utility.goPage(context, 'home');
  //   } catch (e) {
  //     Utility.showSnackBar(context, e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async =>
    //     await LoginController().loginOnlyStorage()
    //         ? Utility.goPage(context, 'home')
    //         : null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleText(name: 'Login Page'),
          TextButton(
            onPressed: () => LoginController().login(),
            child: const Text("Go to Home Page"),
          ),
          TextButton(
            onPressed: () => LoginController().logout(),
            child: const Text("Logout"),
          ),
        ],
      ),
    ]);
  }
}
