import 'package:flutter/material.dart';

class ButtonHeader extends StatefulWidget {
  final List<String> buttons;

  const ButtonHeader({super.key, required this.buttons});

  @override
  State<ButtonHeader> createState() => _ButtonHeaderState();
}

class _ButtonHeaderState extends State<ButtonHeader> {
  @override
  Widget build(BuildContext context) {
    // bisogna mettere da qualche parte lo scroll orizzontale
    return Card(
      elevation: 1,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Icon'),
                  // style: make button outlineVariant,
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Icon'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Icon'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Icon'),
                ),
              ],
            ),
          )),
    );
  }
}
