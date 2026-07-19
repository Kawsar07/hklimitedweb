import 'package:flutter/material.dart';

IconData categoryIcon(String key) {
  switch (key) {
    case 'inverter':
      return Icons.power_rounded;
    case 'panel':
      return Icons.solar_power_rounded;
    case 'mount':
      return Icons.roofing_rounded;
    case 'cable':
      return Icons.cable_rounded;
    case 'accessory':
      return Icons.handyman_rounded;
    case 'controller':
      return Icons.battery_charging_full_rounded;
    case 'monitoring':
      return Icons.monitor_outlined;
    default:
      return Icons.bolt_rounded;
  }
}
