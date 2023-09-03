import 'package:flutter/material.dart';
import 'package:thesis_client/widgets/error_indicator.dart';
import 'package:thesis_client/widgets/progress.dart';

class FutureProgress<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(T data) builder;
  final Widget Function(String error)? builderOnError;
  final Widget Function()? builderOnProgress;

  const FutureProgress({
    super.key,
    this.future,
    required this.builder,
    this.builderOnProgress,
    this.builderOnError,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          if (snapshot.hasData) {
            return builder(snapshot.data as T);
          } else if (snapshot.hasError) {
            if (builderOnError != null) {
              return builderOnError!(snapshot.error.toString());
            }
            return ErrorIndicator(error: snapshot.error.toString());
          } else {
            if (builderOnProgress != null) {
              return builderOnProgress!();
            }
            return const Progress();
          }
        });
  }
}
