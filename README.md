# Animal Avatar Generator

[![CI](https://github.com/TrepnickKev/Animal-Avatar-Generator/actions/workflows/ci.yml/badge.svg)](https://github.com/TrepnickKev/Animal-Avatar-Generator/actions/workflows/ci.yml)

`animal_avatar` is a Flutter package that turns any string into a friendly,
illustrated animal avatar. The avatar is **deterministic**: the same seed always
produces the same picture, on every device and after every reinstall, with no
server and no stored state. Seed it with an e-mail address, a user id, a
Lightning address or a node pubkey and every identity gets a stable, recognisable
face.

Each avatar is composited from hand-tuned art layers:

| Layer | What it is | Options |
|---|---|---|
| Background | A scenic circle: forests, lakes, mountains, coast, by day and night and across the seasons | 15 |
| Animal | The character: fox, owl, otter, badger, cats, dogs, penguins, squirrels, rabbit, duck, sheep, woodpecker, wolves, bull, raccoon, red panda, bird | 24 |
| Detail | Clothing on the chest: scarves, puffer vests, fur-collared jackets, zip coats and hoodies in several colours, or nothing | 31 |
| Badge | An optional Bitcoin themed overlay: gold ₿, glowing ₿, coin, lightning medal, flash on the forehead or chest | 7 |

That is 11,160 distinct animals in their surroundings, and 78,120 looks with a
badge. The badge layer is optional and can be switched off per widget, so the
avatars also work in contexts that have nothing to do with Bitcoin.

## Quick start

```yaml
dependencies:
  animal_avatar:
    git: https://github.com/TrepnickKev/Animal-Avatar-Generator.git
```

```dart
import 'package:animal_avatar/animal_avatar.dart';

// A circular 64x64 avatar for this identity.
AnimalAvatar('alice@example.com', size: 64);

// The same animal, clothes and background, without the badge.
AnimalAvatar('alice@example.com', size: 64, showBadge: false);
```

That is the whole API for the common case. The widget clips itself to a circle
and scales to any `size`.

## How it works

1. The seed string is hashed into a small deterministic random generator.
2. Each slot (background, animal, detail, badge) consumes exactly one draw from
   it and picks an entry from its list in `AvatarLayers`. Because every slot
   always takes one draw, adding a new slot later does not reshuffle the others.
3. The chosen PNGs are stacked back to front with `Image.asset`.

If you need the picks without rendering, for example to cache them or to show
them in a debug screen, call `buildComposition(seed)` and read the resulting
`AvatarComposition`.

```dart
final c = buildComposition('alice@example.com');
print(c.animal);   // assets/animal/animal_fox.png
print(c.detail);   // assets/detail/detail_scarf_green.png
print(c.badge);    // assets/badge/badge_coin.png
```

Until at least one animal is bundled, the widget renders a neutral placeholder
instead of a blank circle.

## Customising the art

All art lives under `assets/<slot>/` as 512×512 PNGs with transparency and is
listed in `lib/src/avatar_layers.dart`. To add, replace or remove a layer:

1. Drop the PNG into the matching `assets/` folder.
2. Add or remove its path in the corresponding list in `avatar_layers.dart`.
3. Run `flutter test`: one test checks that every listed asset really exists in
   the bundle.

The art contract (canvas, placement of faces and collars, how scarves and jackets
line up with the animals) is described in `ASSET_SPEC.md`.

One thing to keep in mind: the pick for a slot is `draw % list.length`, so
changing the length of a list changes which entry existing seeds land on. That is
fine while you are still building your set; once avatars are in the hands of
users, only append to the lists or accept that some avatars will change.

The badge slot is the natural place for your own theme. Swap the Bitcoin badges
for your logo, a rank insignia or nothing at all, and the rest of the avatar is
unaffected.

## Example app

`example/` contains a small desktop preview: ten random avatars, a shuffle
button and a switch for the badge layer.

```powershell
cd example
flutter build windows --release
.\build\windows\x64\runner\Release\example.exe
```

Every push to `main` also builds this preview on GitHub Actions; the portable
folder is attached to the run as the `animal_avatar_preview` artifact.

## Tests

```
flutter analyze
flutter test
```

The tests cover determinism (same seed, same picks), spread across all options,
the one-draw-per-slot guarantee, the badge toggle and the asset manifest.

## Licence

MIT, see `LICENSE`. The illustrations were generated for this project and are
bundled as rendered 512 px layers. The high-resolution source masters are not
part of the repository.
