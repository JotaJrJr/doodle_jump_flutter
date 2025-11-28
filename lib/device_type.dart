import 'package:flutter/material.dart';

enum DeviceType {
  wideScreen(width: 2560, height: 1440, orientation: Orientation.landscape),
  desktop(width: 1920, height: 1080, orientation: Orientation.landscape),
  mobileVertical(width: 360, height: 640, orientation: Orientation.portrait),
  mobileHorizontal(width: 640, height: 360, orientation: Orientation.landscape),
  tabletVertical(width: 800, height: 1280, orientation: Orientation.portrait),
  tabletHorizontal(width: 1280, height: 800, orientation: Orientation.landscape);

  final double width;
  final double height;
  final Orientation orientation;

  const DeviceType({required this.width, required this.height, required this.orientation});

  static DeviceType getDevice(double currentWidth, double currentHeight, Orientation orientation) {
    if (currentWidth >= 1920 && currentHeight <= 900) {
      return DeviceType.desktop;
    }
    if (currentWidth >= 900 && currentHeight >= 900) {
      return orientation == Orientation.portrait ? DeviceType.tabletVertical : DeviceType.tabletHorizontal;
    }
    if (currentWidth < 900 && currentHeight < 900) {
      return orientation == Orientation.portrait ? DeviceType.mobileVertical : DeviceType.mobileHorizontal;
    }
    return DeviceType.wideScreen;
  }

  static DeviceType getNearestDeviceType(double currentWidth, double currentHeight, Orientation currentOrientation, List<DeviceType> deviceTypes) {
    DeviceType? nearestType;
    double minDistance = double.infinity;

    for (var type in deviceTypes) {
      double orientationPenalty = (type.orientation == currentOrientation) ? 0 : 1000;
      // double orientationPenalty = (type.orientation == currentOrientation) ? 0 : 500;

      double distance = (type.width - currentWidth).abs() + (type.height - currentHeight).abs() + orientationPenalty;

      if (distance < minDistance) {
        minDistance = distance;
        nearestType = type;
      }
    }

    print(nearestType.toString());
    print(nearestType?.isMobile.toString());
    print('Altura: ${nearestType?.height}');
    print('Comprimento: ${nearestType?.width}');
    print('Orientação: ${nearestType?.orientation}');

    print('Altura atual: $currentHeight');
    print('Largura atual: $currentWidth');
    print('Orientação atual: $currentOrientation');

    return nearestType!;
  }

  bool isLandscape() {
    return width > height;
  }

  bool isPortrait() {
    return height > width;
  }

  bool get isMobile => this == mobileVertical || this == mobileHorizontal;
  bool get isTablet => this == tabletVertical || this == tabletHorizontal;
  bool get isDesktop => this == desktop || this == wideScreen;
}
