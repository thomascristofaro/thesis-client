import 'package:flutter/material.dart';
import 'package:thesis_client/constants.dart';

class ExpandedTrailingActions extends StatelessWidget {
  final bool useLightMode;
  final bool useMaterial3;
  final ColorSeed colorSelected;
  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function() handleMaterialVersionChange;
  final void Function(int value) handleColorSelect;

  const ExpandedTrailingActions({
    super.key,
    required this.useLightMode,
    required this.useMaterial3,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleMaterialVersionChange,
    required this.handleColorSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(width: 250),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('Brightness'),
              Expanded(child: Container()),
              Switch(
                  value: useLightMode,
                  onChanged: (value) {
                    handleBrightnessChange(value);
                  })
            ],
          ),
          Row(
            children: [
              useMaterial3
                  ? const Text('Material 3')
                  : const Text('Material 2'),
              Expanded(child: Container()),
              Switch(
                  value: useMaterial3,
                  onChanged: (_) {
                    handleMaterialVersionChange();
                  })
            ],
          ),
          const Divider(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200.0),
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                  ColorSeed.values.length,
                      (i) => IconButton(
                    icon: const Icon(Icons.radio_button_unchecked),
                    color: ColorSeed.values[i].color,
                    isSelected: colorSelected.color ==
                        ColorSeed.values[i].color,
                    selectedIcon: const Icon(Icons.circle),
                    onPressed: () {
                      handleColorSelect(i);
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
}