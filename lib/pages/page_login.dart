import 'package:flutter/material.dart';
import 'package:thesis_client/controller/utility.dart';
import 'package:thesis_client/widgets/title_text.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("BLOX"),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TitleText(name: 'Login Page'),
              TextButton(
                onPressed: () {
                  Utility.goPage(context, 'home');
                },
                child: const Text("Go to Home Page"),
              ),
            ],
          ),
        ]));
  }
}
