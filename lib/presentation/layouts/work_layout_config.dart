import 'package:flutter/material.dart';

/// 设备类型
enum DeviceType {
  mobile,
  tablet,
  desktop;

  /// 根据屏幕宽度获取设备类型
  static DeviceType fromWidth(double width) {
    if (width >= WorkLayoutConfig.desktopBreakpoint) return DeviceType.desktop;
    if (width >= WorkLayoutConfig.tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

/// 作品布局配置
class WorkLayoutConfig {
  // 断点
  static const double desktopBreakpoint = 1200;
  static const double tabletBreakpoint = 800;

  // 列数
  static const int desktopColumns = 4;
  static const int tabletColumns = 3;
  static const int mobileColumns = 2;

  // 间距
  static const double desktopSpacing = 20;
  static const double tabletSpacing = 16;
  static const double mobileSpacing = 12;

  // 内边距
  static const EdgeInsets desktopPadding = EdgeInsets.all(24);
  static const EdgeInsets tabletPadding = EdgeInsets.all(18);
  static const EdgeInsets mobilePadding = EdgeInsets.fromLTRB(12, 10, 12, 20);

  const WorkLayoutConfig._();

  /// 根据设备类型获取列数
  static int getColumnsCount(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktopColumns;
      case DeviceType.tablet:
        return tabletColumns;
      case DeviceType.mobile:
        return mobileColumns;
    }
  }

  /// 根据设备类型获取间距
  static double getSpacing(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktopSpacing;
      case DeviceType.tablet:
        return tabletSpacing;
      case DeviceType.mobile:
        return mobileSpacing;
    }
  }

  /// 根据设备类型获取内边距
  static EdgeInsets getPadding(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktopPadding;
      case DeviceType.tablet:
        return tabletPadding;
      case DeviceType.mobile:
        return mobilePadding;
    }
  }
}
