import 'package:flutter/material.dart';
import 'package:thesis_client/widgets/error_indicator.dart';
import 'package:thesis_client/widgets/progress.dart';

class FutureProgress<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(T data) builder;

  const FutureProgress({
    super.key,
    this.future,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          if (snapshot.hasData) {
            return builder(snapshot.data as T);
          } else if (snapshot.hasError) {
            return ErrorIndicator(error: snapshot.error.toString());
          } else {
            return const Progress();
          }
        });
  }
}
