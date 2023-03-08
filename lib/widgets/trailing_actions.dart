import 'package:flutter/material.dart';
import 'package:thesis_client/widgets/brightness_button.dart';
import 'package:thesis_client/widgets/material_3_button.dart';
import 'package:thesis_client/widgets/color_seed_button.dart';
import 'package:thesis_client/constants.dart';

class TrailingActions extends StatelessWidget {
  final ColorSeed colorSelected;
  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function() handleMaterialVersionChange;
  final void Function(int value) handleColorSelect;

  const TrailingActions({
    super.key,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleMaterialVersionChange,
    required this.handleColorSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: BrightnessButton(
            handleBrightnessChange: handleBrightnessChange,
            showTooltipBelow: false,
          ),
        ),
        Flexible(
          child: Material3Button(
            handleMaterialVersionChange: handleMaterialVersionChange,
            showTooltipBelow: false,
          ),
        ),
        Flexible(
          child: ColorSeedButton(
            handleColorSelect: handleColorSelect,
            colorSelected: colorSelected,
          ),
        ),
      ],
    );
  }
}