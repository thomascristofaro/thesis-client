import 'package:flutter/material.dart';
import 'package:thesis_client/constants.dart';
import 'package:thesis_client/controller/login_controller.dart';
import 'package:thesis_client/widgets/title_text.dart';

// se rimane così può diventare stateless
class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  Widget textSubTitle(String name) {
    return Padding(
      padding: const EdgeInsets.all(smallSpacing),
      child: Text(name, style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    LoginController().addListener(update);
  }

  @override
  void dispose() {
    LoginController().removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const TitleText(name: 'Login Page'),
          textSubTitle('Username: ${LoginController().user!.username}'),
          textSubTitle('Email: ${LoginController().user!.email}'),
          textSubTitle('Is Logged: ${LoginController().isLogged()}'),
          Padding(
            padding: const EdgeInsets.all(smallSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(smallSpacing),
                  child: FilledButton.tonalIcon(
                    label: const Text('Login'),
                    icon: const Icon(Icons.login),
                    onPressed: () => LoginController().login(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(smallSpacing),
                  child: FilledButton.tonalIcon(
                      label: const Text('Logout'),
                      icon: const Icon(Icons.logout),
                      onPressed: () => LoginController().logout()),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
