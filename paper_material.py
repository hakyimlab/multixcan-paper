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


def _kot(dwg, _c, text, ox=-40):
    dwg.add(dwg.text(text, insert=(_c[0]+ox, _c[1]+50), fill='black', style="font-size:40;font-family:Arial;font-weight:bold;stroke:black;stroke-width:1;fill:black"))


########################################################################################################################
def run(args):
    if not os.path.exists(args.output_folder):
        os.makedirs(args.output_folder)


if __name__ == "__main__":
    class Dummy(object):
        def __init__(self):
            self.output_folder = "results/paper_material"
            self.plots_folder = "results/plots"
            self.input_folder = "results"
            self.input_folder_2 = "data/images"

    args = Dummy()
    run(args)
