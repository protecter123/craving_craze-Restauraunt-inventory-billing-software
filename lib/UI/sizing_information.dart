import 'package:craving_craze/enums/device_screen_type.dart';
import 'package:flutter/material.dart';

class SizingInformation {
final Orientation? orientation;
final DeviceScreenType? deviceScreenType;
  final Size? screenSize, localWidgetSize;

  SizingInformation(
      { this.orientation,
       this.deviceScreenType,
       this.screenSize,
       this.localWidgetSize});

  @override
  String toString() {
    return 'SizingInformation{orientation: $orientation, deviceScreenType: $deviceScreenType, screenSize: $screenSize, localWidgetSize: $localWidgetSize}';
}
}