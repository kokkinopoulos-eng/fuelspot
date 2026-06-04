import 'package:flutter_test/flutter_test.dart';
import 'package:fuelspot/main.dart';

void main() {
  testWidgets('FuelSpot smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FuelSpotApp());
  });
}
