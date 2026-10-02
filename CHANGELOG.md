# Changelog

## 0.2.0

- Renamed the package to `animal_avatar`; the widget is now `AnimalAvatar` and
  its badge switch `showBadge`. The Bitcoin badges are one optional layer among
  animals, backgrounds and clothing.
- Bundled art: 15 backgrounds, 24 animals, 31 clothing details and 7 badges.
- Reworked from geometric primitives to an **illustrated asset-compositing**
  engine: deterministic hash selects one art layer per slot (background,
  animal, Bitcoin detail, effect) and stacks them. See `ASSET_SPEC.md` for the
  art contract and ChatGPT generation prompts.
- `AnimalAvatar(seed, size:)` API unchanged. Renders a neutral placeholder
  until art is bundled, so it is never blank.
- New: `buildComposition(seed)`, `AvatarComposition`, `AvatarLayers` manifest.

## 0.1.0

- Initial release: deterministic geometric emblem avatars (superseded by 0.2.0).
