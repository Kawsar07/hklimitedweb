import 'package:flutter/material.dart';

IconData categoryIcon(String key) {
  switch (key) {
    case 'inverter':
      return Icons.electrical_services_rounded;
    case 'panel':
      return Icons.solar_power_rounded;
    case 'mount':
      return Icons.roofing_rounded;
    case 'cable':
      return Icons.cable_rounded;
    case 'accessory':
      return Icons.settings_input_component_rounded;
    default:
      return Icons.bolt_rounded;
  }
}
