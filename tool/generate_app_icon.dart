import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final outFile = File('assets/icon/app_icon.png');
  outFile.parent.createSync(recursive: true);

  const size = 1024;
  final canvas = img.Image(width: size, height: size);

  // Background gradient (top-left -> bottom-right)
  const bg1r = 16, bg1g = 185, bg1b = 129; // emerald
  const bg2r = 45, bg2g = 212, bg2b = 191; // teal
  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      final t = ((x + y) / (2 * (size - 1))).clamp(0.0, 1.0);
      final r = (bg1r + (bg2r - bg1r) * t).round();
      final g = (bg1g + (bg2g - bg1g) * t).round();
      final b = (bg1b + (bg2b - bg1b) * t).round();
      canvas.setPixelRgba(x, y, r, g, b, 255);
    }
  }

  // Soft vignette
  final cx = size / 2.0;
  final cy = size / 2.0;
  final maxD = (cx * cx + cy * cy);
  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      final dx = x - cx;
      final dy = y - cy;
      final d = (dx * dx + dy * dy) / maxD;
      final v = (1.0 - d * 0.28).clamp(0.0, 1.0);
      final p = canvas.getPixel(x, y);
      final r = (p.r * v).round();
      final g = (p.g * v).round();
      final b = (p.b * v).round();
      canvas.setPixelRgba(x, y, r, g, b, 255);
    }
  }

  // Paw mark (simple circles + pad), drawn in near-white with shadow.
  final fill = img.ColorRgba8(245, 252, 250, 255);
  final shadow = img.ColorRgba8(0, 0, 0, 44);

  void circle(double x, double y, double r, img.Color color) {
    img.fillCircle(
      canvas,
      x: x.round(),
      y: y.round(),
      radius: r.round(),
      color: color,
    );
  }

  // Center + scale
  final s = size / 1024.0;
  double sx(double x) => x * s;
  double sy(double y) => y * s;
  double sr(double r) => r * s;

  // Shadow offset
  const sh = 12.0;
  void paw(img.Color color, {double dx = 0, double dy = 0}) {
    // Toes
    circle(sx(390 + dx), sy(370 + dy), sr(70), color);
    circle(sx(512 + dx), sy(320 + dy), sr(74), color);
    circle(sx(634 + dx), sy(370 + dy), sr(70), color);
    circle(sx(720 + dx), sy(470 + dy), sr(60), color);

    // Pad
    circle(sx(520 + dx), sy(620 + dy), sr(150), color);
    circle(sx(430 + dx), sy(640 + dy), sr(120), color);
    circle(sx(610 + dx), sy(640 + dy), sr(120), color);
  }

  paw(shadow, dx: sh, dy: sh);
  paw(fill);

  final png = img.encodePng(canvas, level: 6);
  outFile.writeAsBytesSync(png);

  stdout.writeln('Generated ${outFile.path} (${outFile.lengthSync()} bytes)');
}

