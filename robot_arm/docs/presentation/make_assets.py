from pathlib import Path
import csv
import math
from zipfile import ZipFile

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent / "assets"
OUT.mkdir(exist_ok=True)

source_deck = Path("/mnt/d/최종 프로젝트 예시/2팀_최종프로젝트ppt.pptx")
with ZipFile(source_deck) as z:
    (OUT / "kcci_logo.png").write_bytes(z.read("ppt/media/image5.png"))

stack = Image.open(ROOT / "docs/diagrams/robot_arm_sw_stack.png")
stack.crop((65, 235, 2310, 1200)).save(OUT / "sw_stack_body.png")

csv_path = ROOT / "etc/example6_thumb_agent1_result_1280x720_20hz.csv"
with csv_path.open(newline="", encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

t = [float(r["time_sec"]) for r in rows]
valid = [r["target_valid"] == "1" for r in rows]
roll = [float(r["elbow_roll_deg"]) if ok else math.nan for r, ok in zip(rows, valid)]
pitch = [float(r["elbow_pitch_deg"]) if ok else math.nan for r, ok in zip(rows, valid)]

font = FontProperties(fname="/mnt/c/Windows/Fonts/malgun.ttf")
fig, ax = plt.subplots(figsize=(11.8, 4.6), dpi=180)
ax.plot(t, roll, color="#2257B5", lw=2.2, label="팔꿈치 방위각")
ax.plot(t, pitch, color="#ED6B4B", lw=2.2, label="팔꿈치 고도각")
ax.axhline(0, color="#B6C0CC", lw=1)
ax.set_xlim(0, max(t))
ax.set_ylim(-80, 90)
ax.set_xticks([0, 10, 20, 30, 40])
ax.set_yticks([-60, -30, 0, 30, 60, 90])
ax.grid(axis="both", color="#E6EBF1", lw=0.9)
ax.set_xlabel("영상 시간 (초)", fontproperties=font, fontsize=15)
ax.set_ylabel("사람 목표각 (°)", fontproperties=font, fontsize=15)
ax.tick_params(labelsize=12, colors="#465366")
ax.legend(prop=FontProperties(fname="/mnt/c/Windows/Fonts/malgun.ttf", size=15),
          loc="upper right", frameon=False)
for side in ("top", "right"):
    ax.spines[side].set_visible(False)
fig.tight_layout()
fig.savefig(OUT / "example6_angles.png", facecolor="white")
plt.close(fig)

print("rows", len(rows), "valid", sum(valid), "duration", max(t))
