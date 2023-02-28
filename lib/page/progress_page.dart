import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: const [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Awaiting result...'),
          ),
        ],
      )),
    );
  }
}
