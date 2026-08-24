#!/usr/bin/env python3
"""Regenerate the schematic teaser animation used as a publication/project preview.

    python3 bin/make_preview.py assets/img/publication_preview/safety-game.gif

Replace the output with a real render whenever you have one -- this is only a
stand-in so the thumbnail slot is not empty.
"""
import sys, math
import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, Circle
from PIL import Image

OUT = sys.argv[1] if len(sys.argv) > 1 else "assets/img/publication_preview/safety-game.gif"
W, H = 5.2, 3.0          # field, metres -- matches the training geometry
LINE = 1.9               # scoring lines
N = 40                   # frames
RED, BLUE, INK = "#d4443c", "#2c6fbb", "#1b1b1b"


def pose(t):
    """Defender arcs across the field; attacker pursues with a lag."""
    d = np.array([0.35 + 1.15 * math.sin(2 * math.pi * t),
                  0.75 * math.sin(4 * math.pi * t)])
    lag = 0.16
    a = np.array([0.35 + 1.15 * math.sin(2 * math.pi * (t - lag)) - 1.25,
                  0.75 * math.sin(4 * math.pi * (t - lag))])
    return a, d


def robot(ax, xy, heading, color):
    body = FancyBboxPatch((xy[0] - 0.19, xy[1] - 0.11), 0.38, 0.22,
                          boxstyle="round,pad=0.015,rounding_size=0.06",
                          linewidth=0, facecolor=color, zorder=4)
    ax.add_patch(body)
    ax.arrow(xy[0], xy[1], 0.26 * math.cos(heading), 0.26 * math.sin(heading),
             width=0.012, head_width=0.075, head_length=0.075,
             color=color, alpha=0.75, length_includes_head=True, zorder=5)


frames = []
for k in range(N):
    t = k / N
    a, d = pose(t)
    gap = float(np.linalg.norm(a - d))

    fig, ax = plt.subplots(figsize=(4.8, 2.7), dpi=100)
    ax.set_xlim(-W / 2 - 0.15, W / 2 + 0.15)
    ax.set_ylim(-H / 2 - 0.15, H / 2 + 0.15)
    ax.set_aspect("equal")
    ax.axis("off")
    fig.patch.set_facecolor("white")

    ax.add_patch(plt.Rectangle((-W / 2, -H / 2), W, H, fill=False,
                               edgecolor=INK, linewidth=1.4, zorder=1))
    for x, c in ((-LINE, BLUE), (LINE, RED)):
        ax.plot([x, x], [-H / 2, H / 2], linestyle=(0, (5, 4)),
                color=c, linewidth=1.3, alpha=0.65, zorder=2)

    # clearance margin around the defender: amber once the pair is close
    close = gap < 1.05
    ax.add_patch(Circle(d, 0.52, fill=True, facecolor="#f0a63a" if close else BLUE,
                        alpha=0.16 if close else 0.09, linewidth=0, zorder=3))
    ax.add_patch(Circle(d, 0.52, fill=False, edgecolor="#e8952a" if close else BLUE,
                        alpha=0.85 if close else 0.35, linewidth=1.1,
                        linestyle=(0, (3, 3)), zorder=3))

    robot(ax, a, math.atan2(d[1] - a[1], d[0] - a[0]), RED)
    robot(ax, d, math.atan2(-math.cos(4 * math.pi * t), 0.35) + math.pi / 2, BLUE)

    fig.subplots_adjust(left=0.01, right=0.99, top=0.99, bottom=0.01)
    fig.canvas.draw()
    rgba = np.asarray(fig.canvas.buffer_rgba())
    frames.append(Image.fromarray(rgba, "RGBA").convert("RGB"))
    plt.close(fig)

frames = [f.convert("P", palette=Image.ADAPTIVE, colors=64) for f in frames]
frames[0].save(OUT, save_all=True, append_images=frames[1:], loop=0,
               duration=55, optimize=True, disposal=2)
print(f"wrote {OUT}")
