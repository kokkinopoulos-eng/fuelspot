import 'package:flutter/material.dart';

class BrandTheme {
  final Color primary;
  final Color secondary;
  final Color text;
  final Color accent;
  const BrandTheme({required this.primary, required this.secondary, required this.text, required this.accent});
}

class BrandColors {
  static BrandTheme of(String brand) {
    final key = brand.toLowerCase().trim();
    switch (key) {
      case 'eko':      return const BrandTheme(primary: Color(0xFF003DA5), secondary: Color(0xFF002580), text: Colors.white, accent: Color(0xFFFFCC00));
      case 'bp':       return const BrandTheme(primary: Color(0xFF007A33), secondary: Color(0xFF005A25), text: Colors.white, accent: Color(0xFFFFFF00));
      case 'shell':    return const BrandTheme(primary: Color(0xFFDD2000), secondary: Color(0xFFAA1800), text: Colors.white, accent: Color(0xFFFFD500));
      case 'revoil':   return const BrandTheme(primary: Color(0xFFE31837), secondary: Color(0xFFA00020), text: Colors.white, accent: Color(0xFFFFFFFF));
      case 'aegean':   return const BrandTheme(primary: Color(0xFF0078D7), secondary: Color(0xFF0055A0), text: Colors.white, accent: Color(0xFFFFFFFF));
      case 'avin':     return const BrandTheme(primary: Color(0xFFFF6B00), secondary: Color(0xFFCC5500), text: Colors.white, accent: Color(0xFFFFFFFF));
      case 'cyclon':   return const BrandTheme(primary: Color(0xFF1A1A2E), secondary: Color(0xFF0F0F1A), text: Colors.white, accent: Color(0xFF00D4FF));
      case 'mamidoil': return const BrandTheme(primary: Color(0xFF8B0000), secondary: Color(0xFF5A0000), text: Colors.white, accent: Color(0xFFFFD700));
      case 'jetoil':   return const BrandTheme(primary: Color(0xFF2C3E50), secondary: Color(0xFF1A252F), text: Colors.white, accent: Color(0xFF3498DB));
      default:         return const BrandTheme(primary: Color(0xFF1B6CA8), secondary: Color(0xFF0D3F6B), text: Colors.white, accent: Color(0xFF2ECC71));
    }
  }
}
