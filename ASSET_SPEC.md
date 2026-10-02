# animal_avatar — Asset specification

This is the contract between the **art** (one PNG per layer) and the **engine**
(`animal_avatar`, which composites the layers deterministically from a seed).
Art that follows it drops straight into `assets/` with a one-line manifest
change.

## 1. The model

Each avatar stacks one layer per slot, picked from the seed:

```
background   full-bleed scene                      z = 0  (back)
 └ animal    finished character, transparent       z = 1
    └ detail clothing on the chest, or nothing     z = 2
       └ badge  optional overlay (toggle per widget)  z = 3  (front)
```

- An **animal is a finished character**: eyes, mouth, fur and colours are baked
  in. Nothing is recoloured or swapped in code. Variety comes from
  animal × background × detail × badge.
- The **detail** slot holds clothing (scarves, vests, jackets, coats, hoodies).
  "No clothing" is a fully transparent `detail_none.png` listed once, so it has
  the same odds as any single garment.
- The **badge** slot is drawn last and only when the widget's `showBadge` is
  true. It is the place for a theme (Bitcoin here) that can be swapped or
  dropped without touching the rest of the set.

## 2. Canvas and registration

All masters are worked at **1024 × 1024** and shipped at **512 × 512** PNG with
alpha, sRGB. The numbers below are in master (1024) coordinates; halve them for
the shipped files.

| Feature | Position |
|---|---|
| Eye line of every animal | y ≈ 585, eyes about 240 px apart, face centred on x = 512 |
| Bottom of every animal | flush with the canvas bottom (y = 1023), flat cut; the circle mask hides the edge |
| Top of the clothing collar | y ≈ 730 (scarf top); the chin of every animal rests on or just above it |
| Clothing width | garments are widened 10% around x = 512 so they cover the widest ruffs (owls, wolves) |
| Centred badges (coin, ₿, medal) | centre (512, ≈ 940), about 160 px across |
| Forehead badges | centre (512, 420), about 150 px tall |
| Safe circle | keep anything that must stay visible inside Ø ≈ 880 px around the centre |

Animals are placed by matching their eyes to the eye line; animals with
oversized eyes (birds) are matched by head width instead. Garments all share
one transform derived from the squirrel they were drawn on, so a new garment
drawn on that same squirrel pose lines up automatically.

## 3. Slots and naming

Lowercase, `slot_name.png`, no spaces:

```
background/bg_forest_night.png    background/bg_lake_winter.png
animal/animal_fox.png             animal/animal_cat_shorthair_sand.png
detail/detail_none.png            detail/detail_scarf_green.png   detail/detail_hoodie_black.png
badge/badge_coin.png              badge/badge_flash_glow_forehead.png
```

`lib/src/avatar_layers.dart` lists what is bundled and is the source of truth.
Changing the length of a list changes which entry existing seeds land on, so
once avatars are live, append rather than reorder.

## 4. Producing new art

- **Backgrounds**: a circular scene on white; the white outside the circle is
  removed by a flood fill from the borders.
- **Animals**: head-and-shoulders, facing forward, centred, on a transparent or
  checkerboard background. Pale animals (sheep, white wolves, penguin bellies)
  must not touch the canvas bottom with white, or the flood fill will eat into
  them; if they do, the extraction is seeded from the top and sides only.
- **Clothing**: draw the garment on the reference squirrel pose; the face is
  flooded out and the garment is kept. Colour variants are made by recolouring
  the fabric only, so zippers, fur collars and cords keep their look.
- **Badges**: a single object on a plain background; it is cut out, scaled and
  placed at one of the two positions in §2.

Style line used for every generation prompt, so the set stays consistent:

> Flat vector-style mascot illustration, thick clean outlines, soft cel shading,
> friendly modern aesthetic, bold shapes, high contrast, centred,
> head-and-shoulders sticker framing.

## 5. Drop-in checklist

- [ ] 512² (or a 1024² master to downscale), PNG with alpha, sRGB.
- [ ] Registered as in §2: eyes on the eye line, bottom flush, collar at the scarf top.
- [ ] Named per §3 and placed in `assets/<slot>/`.
- [ ] Listed in `avatar_layers.dart`; `flutter test` passes (the manifest test loads every file).
