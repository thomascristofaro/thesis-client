import 'package:flutter/material.dart';

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
          } else {
            return Column(
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
            );
          }
        });
  }
}
