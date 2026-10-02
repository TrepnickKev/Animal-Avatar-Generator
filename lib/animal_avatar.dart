/// Deterministic animal avatars, composited from illustrated layers selected
/// by a seed hash. An optional badge layer (Bitcoin themed by default) can be
/// toggled per widget.
///
/// ```dart
/// AnimalAvatar('alice@example.com', size: 64)
/// ```
library;

export 'src/animal_avatar.dart' show AnimalAvatar;
export 'src/avatar_composition.dart' show AvatarComposition, buildComposition;
export 'src/avatar_layers.dart' show AvatarLayers;
export 'src/palette.dart' show AvatarPalette, kPalettes, bitcoinOrange;
