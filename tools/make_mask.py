"""Builds Media/Round10.tga .. Media/Round100.tga: white squares whose corner radius is
10% .. 100% of half the side, so 100% is a full circle. Used as icon masks and as the
cooldown swipe, picked by the "Corner rounding" sliders."""
from PIL import Image, ImageDraw

SIZE, SCALE = 64, 8
for pct in range(10, 101, 10):
    radius = SIZE / 2 * pct / 100
    big = Image.new("L", (SIZE * SCALE, SIZE * SCALE), 0)
    ImageDraw.Draw(big).rounded_rectangle((0, 0, SIZE * SCALE - 1, SIZE * SCALE - 1),
                                          radius=radius * SCALE, fill=255)
    img = Image.new("RGBA", (SIZE, SIZE), (255, 255, 255, 0))
    img.putalpha(big.resize((SIZE, SIZE), Image.LANCZOS))
    img.save(f"addon/TargetInCombat/Media/Round{pct}.tga")
print("10 masks written to addon/TargetInCombat/Media")
