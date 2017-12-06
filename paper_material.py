#! /usr/bin/env python
import os
import subprocess
import svgwrite
import math
import shutil

########################################################################################################################
def ensure_requisite_folders(path):
    folder = os.path.split(path)[0]
    if len(folder) and not os.path.exists(folder):
        os.makedirs(folder)

def _png_name(p):
    return p.split(".svg")[0]+".png"

def to_png(from_path, to_path):
    ensure_requisite_folders(to_path)
    cmd = \
"""
convert {} {}
""".format(from_path, to_path)
    subprocess.call(cmd.split())

def _advance_cursor(c, x, y):
    return (c[0]+x, c[1]+y)


def _kot(dwg, _c, text, ox=-40, oy=50):
    dwg.add(dwg.text(text, insert=(_c[0]+ox, _c[1]+oy), fill='black', style="font-size:40;font-family:Arial;font-weight:bold;stroke:black;stroke-width:1;fill:black"))

def figure_1(args):
    _p = "_fig1.svg"#os.path.join(args.output_folder, "fig1.svg")

    # diagram is (341,972); plots are 600,600
    _1_size = (341, 972)
    _2_size = (470, 470)
    _size = (_1_size[0]+130+_2_size[0], 980)

    dwg = svgwrite.Drawing(_p, size=_size)
    dwg.add(dwg.rect(insert=(0, 0), size=_size, fill="rgb(255,255,255)"))

    _c = (40,0) # conceptual cursor
    dwg.add(dwg.image(os.path.join(args.input_folder_2, "S-Predixcan-MT-diagram.png"), _c, _1_size))
    _kot(dwg, _c, "a", ox=-30, oy=30)

    _c = _advance_cursor(_c, _1_size[0]+90,0)
    dwg.add(dwg.image(os.path.join(args.plots_folder, "ukb", "UKB_Cholesterol_qq.png"), _c, _2_size))
    _kot(dwg, _c, "b", ox=-20, oy=30)

    _c =_advance_cursor (_c, 0, _2_size[1]+40)
    dwg.add(dwg.image(os.path.join(args.plots_folder, "ukb", "UKB_Cholesterol_significant_bars.png"), _c, _2_size))
    _kot(dwg, _c, "c", ox=-20, oy=30)

    dwg.save()
    t = os.path.join(args.output_folder, "fig-multi-tissue-better-than-predixcan.png")
    to_png(_p, t)
    os.remove(_p)

########################################################################################################################
def run(args):
    if not os.path.exists(args.output_folder):
        os.makedirs(args.output_folder)

    figure_1(args)

if __name__ == "__main__":
    class Dummy(object):
        def __init__(self):
            self.output_folder = "results/paper_material"
            self.plots_folder = "results/plots"
            self.input_folder = "results"
            self.input_folder_2 = "data/images"

    args = Dummy()
    run(args)
