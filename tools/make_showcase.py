"""Builds docs/showcase.png: one labeled image of every look, from the blurred screenshots,
for posts where a single picture works better than a gallery."""
import os
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.join(os.path.dirname(__file__), "..")
SHOTS = os.path.join(ROOT, "docs", "screenshots")

# (label, nameplate shot, crop box or None, portrait shot)
ROWS = [
    ("In combat", "combat-plate", (0, 0, 262, 60), "combat-target"),
    ("Out of combat (optional Zzz)", "zzz-plate", (0, 0, 246, 50), "zzz-target"),
    ("Sap lands now", "sap-ready-plate", (0, 0, 285, 60), "sap-ready-target"),
    ("Sappable, out of range", "sap-far-player-plate", None, "sap-far-player-target"),
    ("Not sappable: beast", "sap-no-beast-plate", (0, 0, 246, 60), "sap-no-beast-target"),
    ("Not sappable: cat form", "sap-no-druid-form-plate", (0, 0, 260, 50), "sap-no-druid-form-target"),
]

def font(size, bold=True):
    for name in (("arialbd.ttf" if bold else "arial.ttf"), "DejaVuSans-Bold.ttf"):
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            pass
    return ImageFont.load_default()

LABEL_W, COL_W, ROW_H, PAD = 300, 320, 110, 16
TITLE_H = 90
TIMER_H = 120
W = LABEL_W + 2 * COL_W + PAD * 2
H = TITLE_H + 40 + ROW_H * len(ROWS) + TIMER_H + PAD

img = Image.new("RGB", (W, H), (18, 18, 22))
d = ImageDraw.Draw(img)
d.text((PAD, 18), "Target In Combat - TIC", font=font(40), fill=(240, 200, 80))
d.text((PAD, 64), "WoW Forever: combat state on nameplates and target portrait, Sap helper for rogues",
       font=font(18, False), fill=(200, 200, 200))
d.text((PAD + LABEL_W, TITLE_H + 8), "Nameplate", font=font(20), fill=(170, 170, 170))
d.text((PAD + LABEL_W + COL_W, TITLE_H + 8), "Target portrait", font=font(20), fill=(170, 170, 170))

def paste_fit(name, box, x, y, w, h):
    shot = Image.open(os.path.join(SHOTS, name + ".png")).convert("RGB")
    if box:
        shot = shot.crop(box)
    scale = min(w / shot.width, h / shot.height, 1.4)
    shot = shot.resize((int(shot.width * scale), int(shot.height * scale)), Image.LANCZOS)
    img.paste(shot, (x, y + (h - shot.height) // 2))

y = TITLE_H + 40
for label, plate, box, target in ROWS:
    d.line((PAD, y, W - PAD, y), fill=(50, 50, 58), width=1)
    d.text((PAD, y + ROW_H // 2 - 12), label, font=font(22), fill=(235, 235, 235))
    paste_fit(plate, box, PAD + LABEL_W, y + 8, COL_W - 20, ROW_H - 16)
    paste_fit(target, None, PAD + LABEL_W + COL_W, y + 8, COL_W - 20, ROW_H - 16)
    y += ROW_H

d.line((PAD, y, W - PAD, y), fill=(50, 50, 58), width=1)
d.text((PAD, y + 40), "Sap timer (seconds left)", font=font(22), fill=(235, 235, 235))
paste_fit("sap-timer-plate", (0, 0, 270, 60), PAD + LABEL_W, y + 10, COL_W - 20, TIMER_H - 20)

out = os.path.join(ROOT, "docs", "showcase.png")
img.save(out)
print(out)
