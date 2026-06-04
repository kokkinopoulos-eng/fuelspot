import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  final String brand;
  final double size;

  const BrandLogo({super.key, required this.brand, this.size = 40});

  String? get _logoUrl {
    switch (brand.toLowerCase()) {
      case 'eko':      return 'https://www.eko.gr/favicon.ico';
      case 'bp':       return 'https://www.bp.com/favicon.ico';
      case 'shell':    return 'https://www.shell.com/favicon.ico';
      case 'revoil':   return 'https://www.revoil.gr/favicon.ico';
      case 'aegean':   return 'https://www.aegean-oil.gr/favicon.ico';
      case 'avin':     return 'https://www.avin.gr/favicon.ico';
      case 'cyclon':   return 'https://www.cyclon.gr/favicon.ico';
      case 'mamidoil': return 'https://www.mamidoil.gr/favicon.ico';
      case 'jetoil':   return 'https://www.jetoil.gr/favicon.ico';
      default:         return null;
    }
  }

  Color get _brandColor {
    switch (brand.toLowerCase()) {
      case 'eko':      return const Color(0xFF003DA5);
      case 'bp':       return const Color(0xFF007A33);
      case 'shell':    return const Color(0xFFFFD500);
      case 'revoil':   return const Color(0xFFE31837);
      case 'aegean':   return const Color(0xFF0078D7);
      case 'avin':     return const Color(0xFFFF6B00);
      case 'cyclon':   return const Color(0xFF1A1A2E);
      case 'mamidoil': return const Color(0xFF8B0000);
      case 'jetoil':   return const Color(0xFF2C3E50);
      default:         return const Color(0xFF546E7A);
    }
  }

  String get _initials {
    if (brand.isEmpty) return '⛽';
    return brand.substring(0, brand.length >= 3 ? 3 : brand.length).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final url = _logoUrl;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: _brandColor.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2 - 1),
        child: url != null
          ? Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _fallback(),
              loadingBuilder: (_, child, loading) => loading == null ? child : _fallback(),
            )
          : _fallback(),
      ),
    );
  }

  Widget _fallback() => Container(
    color: _brandColor,
    child: Center(
      child: Text(
        _initials,
        style: TextStyle(
          color: brand.toLowerCase() == 'shell' ? const Color(0xFFDD2000) : Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: size * 0.3,
        ),
      ),
    ),
  );
}
