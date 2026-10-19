"""Generate the presentation SW stack as PNG, SVG, and editable draw.io."""

from pathlib import Path
import xml.etree.ElementTree as ET
from xml.dom import minidom

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
from matplotlib.patches import Rectangle

OUT = Path(__file__).resolve().parent
REG = FontProperties(fname="/mnt/c/Windows/Fonts/malgun.ttf")
BOLD = FontProperties(fname="/mnt/c/Windows/Fonts/malgunbd.ttf")
plt.rcParams["svg.fonttype"] = "none"

NAVY = "#173A91"
INK = "#172033"
EDGE = "#B9C8D7"
LAYERS = [
    ("Application", 158, 289, "#E5F2E2", "#88B27C"),
    ("Driver", 471, 93, "#EEE8F5", "#B59BCB"),
    ("HAL", 586, 93, "#F0EAF7", "#B59BCB"),
    ("HW", 701, 98, "#E7F0FC", "#8BACD8"),
]
APP = ["Pose Mapping", "Motion Control", "Record / Replay", "Servo Control"]
DRIVER = ["CNN Input", "UART Driver", "Timer Driver", "PWM Driver"]
HAL = ["Interrupt", "UART", "Timer", "Register I/O"]
HW = ["CNN IP", "PS UART", "AXI Timer", "PWM IP", "5 Servos"]

fig, ax = plt.subplots(figsize=(16, 9), dpi=120)
fig.patch.set_facecolor("white")
ax.set_xlim(0, 1600)
ax.set_ylim(900, 0)
ax.axis("off")

def rect(x, y, w, h, fill, edge="none", lw=1):
    ax.add_patch(Rectangle((x, y), w, h, facecolor=fill, edgecolor=edge, linewidth=lw))

def txt(x, y, value, size=18, bold=False, color=INK):
    ax.text(x, y, value, va="center", ha="center", fontsize=size, color=color,
            fontproperties=BOLD if bold else REG)

def box(x, y, w, h, value, fill="#FFFFFF", edge=EDGE, size=20):
    rect(x, y, w, h, fill, edge, 1.35)
    txt(x+w/2, y+h/2, value, size, True)

txt(312, 76, "Robot Arm SW Stack", 31, True, "#102D69")
rect(65, 116, 1470, 2, "#D5DDE8")

for name, y, h, fill, stroke in LAYERS:
    rect(250, y, 1285, h, fill, stroke, 1.2)
    rect(51, y+h/2-29, 176, 58, NAVY)
    txt(139, y+h/2, name, 16 if name == "Application" else 20, True, "#FFFFFF")

box(484, 178, 816, 67, "Main Control", "#FFF1CE", "#D9AD4F", 23)
for i, label in enumerate(APP):
    box(273+i*315, 290, 296, 129, label, "#FFFFFF", "#91B68B", 20)
for i, label in enumerate(DRIVER):
    box(273+i*315, 485, 296, 64, label, "#FFFFFF", "#B59BCB", 18)
for i, label in enumerate(HAL):
    box(273+i*315, 600, 296, 64, label, "#FFFFFF", "#B59BCB", 18)
for i, label in enumerate(HW):
    box(273+i*252, 715, 236, 70, label, "#FFFFFF", "#8BACD8", 17)

for ext in ("svg", "png"):
    fig.savefig(OUT/f"robot_arm_sw_stack.{ext}",
                dpi=150 if ext == "png" else None, facecolor="white", pad_inches=0)
plt.close(fig)

mxfile = ET.Element("mxfile", host="app.diagrams.net", agent="Codex",
                    version="24.7.17", type="device")
diagram = ET.SubElement(mxfile, "diagram", id="robot-sw-stack", name="SW Stack")
model = ET.SubElement(diagram, "mxGraphModel", dx="1600", dy="900", grid="1",
                      gridSize="10", guides="1", tooltips="1", connect="1",
                      arrows="1", fold="1", page="1", pageScale="1",
                      pageWidth="1600", pageHeight="900", math="0", shadow="0")
root = ET.SubElement(model, "root")
ET.SubElement(root, "mxCell", id="0")
ET.SubElement(root, "mxCell", id="1", parent="0")

def cell(ident, value, style, x, y, w, h):
    c = ET.SubElement(root, "mxCell", id=ident, value=value,
                      style=style, vertex="1", parent="1")
    ET.SubElement(c, "mxGeometry", x=str(x), y=str(y), width=str(w),
                  height=str(h), **{"as": "geometry"})

def dc_rect(ident, x, y, w, h, fill, stroke="none"):
    cell(ident, "", f"rounded=0;html=1;fillColor={fill};strokeColor={stroke};",
         x, y, w, h)

def dc_text(ident, value, x, y, w, h, size, color=INK, bold=True):
    style=("text;html=1;whiteSpace=wrap;verticalAlign=middle;align=center;"
           f"fontFamily=Malgun Gothic;fontSize={size};fontColor={color};"
           f"fontStyle={1 if bold else 0};fillColor=none;strokeColor=none;")
    cell(ident, value, style, x, y, w, h)

def dc_box(ident, x, y, w, h, value, fill="#FFFFFF", stroke=EDGE, size=25):
    dc_rect(ident+"_bg", x, y, w, h, fill, stroke)
    dc_text(ident+"_text", value, x+6, y+5, w-12, h-10, size)

dc_text("title", "Robot Arm SW Stack", 65, 39, 730, 73, 42, "#102D69")
dc_rect("rule", 65, 116, 1470, 2, "#D5DDE8")
for i, (name, y, h, fill, stroke) in enumerate(LAYERS):
    dc_rect(f"layer{i}", 250, y, 1285, h, fill, stroke)
    dc_rect(f"tag{i}", 51, y+h/2-29, 176, 58, NAVY)
    dc_text(f"tagtext{i}", name, 51, y+h/2-29, 176, 58,
            20 if name == "Application" else 27, "#FFFFFF")

dc_box("main", 484, 178, 816, 67, "Main Control", "#FFF1CE", "#D9AD4F", 31)
for i, label in enumerate(APP):
    dc_box(f"app{i}", 273+i*315, 290, 296, 129, label, stroke="#91B68B", size=27)
for i, label in enumerate(DRIVER):
    dc_box(f"driver{i}", 273+i*315, 485, 296, 64, label, stroke="#B59BCB", size=24)
for i, label in enumerate(HAL):
    dc_box(f"hal{i}", 273+i*315, 600, 296, 64, label, stroke="#B59BCB", size=24)
for i, label in enumerate(HW):
    dc_box(f"hw{i}", 273+i*252, 715, 236, 70, label, stroke="#8BACD8", size=23)

out = OUT / "robot_arm_sw_stack.drawio"
out.write_bytes(minidom.parseString(ET.tostring(mxfile, encoding="utf-8"))
                .toprettyxml(indent="  ", encoding="utf-8"))
ET.parse(out)
print(OUT / "robot_arm_sw_stack.png")
print(OUT / "robot_arm_sw_stack.svg")
print(out)
