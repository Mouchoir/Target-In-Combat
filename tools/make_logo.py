"""Draws the CurseForge project logo: red crossed swords over a dark disc, "TIC" below.

With --zzz, a yellow growing "zZZ" sits behind the swords (logo-400-zzz.png)."""
import math
import sys
from PIL import Image, ImageDraw, ImageFont

S = 1600  # draw large, downscale for smooth edges
img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
d = ImageDraw.Draw(img)

d.ellipse((40, 40, S - 40, S - 40), fill=(24, 22, 28, 255), outline=(200, 160, 60, 255), width=48)

def sword(angle):
    cx, cy = S / 2, S * 0.43
    a = math.radians(angle)
    ux, uy = math.sin(a), -math.cos(a)  # along the blade
    px, py = -uy, ux                     # across the blade
    def pt(along, across):
        return (cx + ux * along + px * across, cy + uy * along + py * across)
    blade = [pt(-260, -42), pt(380, -42), pt(470, 0), pt(380, 42), pt(-260, 42)]
    guard = [pt(-250, -150), pt(-200, -150), pt(-200, 150), pt(-250, 150)]
    grip = [pt(-430, -30), pt(-250, -30), pt(-250, 30), pt(-430, 30)]
    d.polygon(blade, fill=(220, 40, 40, 255), outline=(90, 10, 10, 255), width=14)
    d.polygon(guard, fill=(200, 160, 60, 255))
    d.polygon(grip, fill=(120, 80, 40, 255))
    x, y = pt(-470, 0)
    d.ellipse((x - 48, y - 48, x + 48, y + 48), fill=(200, 160, 60, 255))

ZZZ = "--zzz" in sys.argv
if ZZZ:
    # Rising z, Z, Z behind the swords, top right, like the player frame's rest icon.
    for size, x, y in ((130, 0.60, 0.33), (180, 0.655, 0.23), (230, 0.715, 0.12)):
        try:
            zfont = ImageFont.truetype("arialbd.ttf", size)
        except OSError:
            zfont = ImageFont.load_default()
        d.text((S * x, S * y), "z" if size == 130 else "Z", font=zfont, fill=(255, 210, 40, 255),
               stroke_width=10, stroke_fill=(60, 40, 0, 255))

sword(45)
sword(-45)

try:
    font = ImageFont.truetype("arialbd.ttf", 330)
except OSError:
    font = ImageFont.load_default()
text = "TIC"
w = d.textlength(text, font=font)
d.text(((S - w) / 2, S * 0.66), text, font=font, fill=(240, 230, 210, 255),
       stroke_width=14, stroke_fill=(0, 0, 0, 255))

out = "docs/logo-400-zzz.png" if ZZZ else "docs/logo-400.png"
img.resize((400, 400), Image.LANCZOS).save(out)
print(out)
