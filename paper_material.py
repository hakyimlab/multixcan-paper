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


def _kot(dwg, _c, text, ox=-40, oy=50, style="font-size:40;font-family:Arial;font-weight:bold;stroke:black;stroke-width:1;fill:black"):
    dwg.add(dwg.text(text, insert=(_c[0]+ox, _c[1]+oy), fill='black', style=style))

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

def figure_3(args):
    _p = "_fig3.svg"#os.path.join(args.output_folder, "fig1.svg")

    _1_size = (800, 800)
    _size = (_1_size[0]*2+100, _1_size[1])

    dwg = svgwrite.Drawing(_p, size=_size)
    dwg.add(dwg.rect(insert=(0, 0), size=_size, fill="rgb(255,255,255)"))

    _c = (50,0) # conceptual cursor
    dwg.add(dwg.image(os.path.join(args.plots_folder, "gwas", "smt_vs_sp_number_significant.png"), _c, _1_size))
    _kot(dwg, _c, "a", ox=-30, oy=50, style="font-size:60;font-family:Arial;font-weight:bold;stroke:black;stroke-width:1;fill:black")

    _c =_advance_cursor (_c, _1_size[0]+40, 0)
    dwg.add(dwg.image(os.path.join(args.plots_folder, "gwas", "smt_only_vs_sp_only_number_significant.png"), _c, _1_size))
    _kot(dwg, _c, "b", ox=-30, oy=50, style="font-size:60;font-family:Arial;font-weight:bold;stroke:black;stroke-width:1;fill:black")

    dwg.save()
    t = os.path.join(args.output_folder, "fig-gwas-smt-vs-sp-significant.png")
    to_png(_p, t)
    os.remove(_p)

def figure_4(args):
    _p = "_fig4.svg"#os.path.join(args.output_folder, "fig1.svg")

    # diagram is (341,972); plots are 600,600
    _1_size = (600, 600)
    _size = (_1_size[0]*2+80, _1_size[1])

    dwg = svgwrite.Drawing(_p, size=_size)
    dwg.add(dwg.rect(insert=(0, 0), size=_size, fill="rgb(255,255,255)"))

    _c = (40,0) # conceptual cursor
    dwg.add(dwg.image(os.path.join(args.plots_folder, "gwas", "PGC_scz2_qq.png"), _c, _1_size))
    _kot(dwg, _c, "a", ox=-20, oy=30)

    _c =_advance_cursor (_c, _1_size[1]+40, 0)
    dwg.add(dwg.image(os.path.join(args.plots_folder, "gwas", "PGC_scz2_significant_bars.png"), _c, _1_size))
    _kot(dwg, _c, "b", ox=-20, oy=30)

    dwg.save()
    t = os.path.join(args.output_folder, "fig-scz2-smt-vs-sp.png")
    to_png(_p, t)
    os.remove(_p)

def shove(args):
    def _shove(args, files, file_prefix=""):
        for sf in files:
            shutil.copy(os.path.join(args.plots_folder, *sf),
                        os.path.join(args.output_folder, file_prefix + sf[len(sf) - 1].replace("_", "-")))

    figures = [("ukb","smt_vs_mt_ukb.png",)]
    _shove(args, figures, file_prefix="fig-")

    supp_figures = [("ukb", "smt_vs_mt_ukb_1.png",),
                    ("ukb", "smt_vs_mt_ukb_2.png",)]
    _shove(args, supp_figures, "supp-fig-")

########################################################################################################################
def run(args):
    if not os.path.exists(args.output_folder):
        os.makedirs(args.output_folder)

    shove(args)
    figure_1(args)
    figure_3(args)
    figure_4(args)

if __name__ == "__main__":
    class Dummy(object):
        def __init__(self):
            self.output_folder = "results/paper_material"
            self.plots_folder = "results/plots"
            self.input_folder = "results"
            self.input_folder_2 = "data/images"

    args = Dummy()
    run(args)
