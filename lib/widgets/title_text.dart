import 'package:flutter/material.dart';
import 'package:thesis_client/constants.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(smallSpacing),
      child: Text(name, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
