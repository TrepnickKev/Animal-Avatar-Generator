import 'package:animal_avatar/animal_avatar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Synthetic layer sets so selection can be exercised before real art exists.
  const bgs = ['bg_a', 'bg_b', 'bg_c'];
  const animals = ['fox', 'bear', 'owl', 'wolf', 'cat'];
  const details = ['btc', 'bolt'];
  const effects = ['none', 'embers'];

  AvatarComposition compose(String seed) => buildComposition(
        seed,
        backgrounds: bgs,
        animals: animals,
        details: details,
        effects: effects,
      );

  group('buildComposition', () {
    test('same seed yields an identical composition across calls', () {
      for (final seed in ['satoshi@x', 'kevin@lnbits.trepnick.de', '', 'a']) {
        expect(compose(seed).toString(), compose(seed).toString());
      }
    });

    test('distinct seeds spread across every option in each slot', () {
      final b = <String?>{}, a = <String?>{}, d = <String?>{}, e = <String?>{};
      for (var i = 0; i < 300; i++) {
        final c = compose('identity-$i@wallet');
        b.add(c.background);
        a.add(c.animal);
        d.add(c.detail);
        e.add(c.effect);
      }
      expect(a.length, animals.length);
      expect(b.length, bgs.length);
      expect(d.length, details.length);
      expect(e.length, effects.length);
    });

    test('one draw per slot: adding a slot does not re-roll the others', () {
      // Same seed; only the effects slot differs. Background/animal/detail
      // picks must be unchanged because each slot consumes exactly one draw.
      final withEffects = buildComposition('stable-seed',
          backgrounds: bgs, animals: animals, details: details, effects: effects);
      final withoutEffects = buildComposition('stable-seed',
          backgrounds: bgs, animals: animals, details: details, effects: const []);
      expect(withEffects.background, withoutEffects.background);
      expect(withEffects.animal, withoutEffects.animal);
      expect(withEffects.detail, withoutEffects.detail);
      expect(withoutEffects.effect, isNull);
    });

    test('empty animal slot means no art -> fallback', () {
      final c = buildComposition('seed', animals: const []);
      expect(c.usesArt, isFalse);
      expect(c.animal, isNull);
    });

    test('badge slot: same seed picks the same badge; not part of layers', () {
      const badges = ['b1', 'b2'];
      final a = buildComposition('stable-seed',
          backgrounds: bgs, animals: animals, details: details,
          effects: effects, badges: badges);
      final b = buildComposition('stable-seed',
          backgrounds: bgs, animals: animals, details: details,
          effects: effects, badges: badges);
      expect(a.badge, b.badge);
      expect(badges.contains(a.badge), isTrue);
      // The badge draw must not disturb the other slots vs an empty badge list.
      final none = buildComposition('stable-seed',
          backgrounds: bgs, animals: animals, details: details,
          effects: effects, badges: const []);
      expect(none.badge, isNull);
      expect(a.background, none.background);
      expect(a.animal, none.animal);
      expect(a.detail, none.detail);
      expect(a.effect, none.effect);
      // Badge is toggled by the widget, so it never appears in layers.
      expect(a.layers.contains(a.badge), isFalse);
    });

    test('layers list is back-to-front and skips empty slots', () {
      final c = buildComposition('seed',
          backgrounds: bgs, animals: animals, details: const [], effects: effects);
      expect(c.layers.first, c.background);
      expect(c.layers.contains(c.animal), isTrue);
      expect(c.layers.length, 3); // no detail
    });
  });
}
