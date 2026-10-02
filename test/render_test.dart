import 'package:animal_avatar/animal_avatar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimalAvatar render', () {
    testWidgets('renders without throwing', (tester) async {
      for (final size in [44.0, 88.0]) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: AnimalAvatar('render-$size@wallet', size: size),
            ),
          ),
        );
        expect(find.byType(AnimalAvatar), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('AvatarLayers manifest', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Every manifest entry must resolve to a bundled asset, otherwise that
    // layer silently disappears at runtime (the widget's errorBuilder hides
    // missing files by design).
    final allPaths = [
      ...AvatarLayers.backgrounds,
      ...AvatarLayers.animals,
      ...AvatarLayers.details,
      ...AvatarLayers.effects,
      ...AvatarLayers.badges,
    ];

    test('every listed asset exists in the bundle', () async {
      for (final path in allPaths) {
        final data = await rootBundle.load(path);
        expect(data.lengthInBytes, greaterThan(0), reason: path);
      }
    });
  });
}
