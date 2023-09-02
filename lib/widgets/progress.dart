import 'package:flutter/material.dart';
import 'package:thesis_client/constants.dart';
import 'package:thesis_client/widgets/title_text.dart';

class Progress extends StatelessWidget {
  const Progress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: indicatorSize,
            height: indicatorSize,
            child: CircularProgressIndicator(),
          ),
          TitleText(name: "Awaiting result...")
        ],
      ),
    );
  }
}
