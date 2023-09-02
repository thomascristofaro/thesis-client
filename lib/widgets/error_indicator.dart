import 'package:flutter/material.dart';
import 'package:thesis_client/constants.dart';
import 'package:thesis_client/widgets/title_text.dart';

class ErrorIndicator extends StatelessWidget {
  final String error;
  const ErrorIndicator({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: indicatorSize,
            height: indicatorSize,
            child: Icon(
              Icons.warning,
              size: indicatorSize,
              color: Colors.red,
            ),
          ),
          TitleText(name: error)
        ],
      ),
    );
  }
}
