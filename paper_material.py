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
    _3_size = (455.0*470/571, 470)
    _size = (_1_size[0]+180+_2_size[0]*2, 980)

    dwg = svgwrite.Drawing(_p, size=_size)
    dwg.add(dwg.rect(insert=(0, 0), size=_size, fill="rgb(255,255,255)"))

    _c = (40,0) # conceptual cursor
    dwg.add(dwg.image(os.path.join(args.input_folder_2, "S-Predixcan-MT-diagram.png"), _c, _1_size))
    _kot(dwg, _c, "a", ox=-30, oy=30)

    _c = _advance_cursor(_c, _1_size[0]+90,0)
    dwg.add(dwg.image(os.path.join(args.plots_folder, "ukb", "UKB_Cholesterol_qq.png"), _c, _2_size))
    _kot(dwg, _c, "b", ox=-20, oy=30)

    _c =_advance_cursor (_c, _2_size[0]+50, 0)
    dwg.add(dwg.image(os.path.join(args.plots_folder, "ukb", "UKB_Cholesterol_significant_bars.png"), _c, _2_size))
    _kot(dwg, _c, "c", ox=-20, oy=30)

    _c = (_1_size[0] + 130 + math.ceil((_2_size[0]-_3_size[0])/2.0), _2_size[1] + 40)
    dwg.add(dwg.image(os.path.join(args.input_folder_2, "tissuexcan_illustration.png"), _c, _2_size))
    _kot(dwg, _c, "d", ox=-20, oy=30)

    _c =_advance_cursor (_c, _2_size[0]+50, 0)
    dwg.add(dwg.image(os.path.join(args.plots_folder, "ukb", "ukb_mt_vs_p_number_significant.png"), _c, _2_size))
    _kot(dwg, _c, "e", ox=-20, oy=30)

    dwg.save()
    t = os.path.join(args.output_folder, "fig-multi-tissue-better-than-predixcan.png")
    to_png(_p, t)
    os.remove(_p)


def figure_2(args):
    _p = "_fig2.svg"#os.path.join(args.output_folder, "fig1.svg")

    # diagram is (341,972); plots are 600,600; illustration is 455,571
    _1_size = (600, 600)
    _2_size = (600, 507*600.0/610)
    _size = (_1_size[0]*2+80, _1_size[1]*2+40)

    dwg = svgwrite.Drawing(_p, size=_size)
    dwg.add(dwg.rect(insert=(0, 0), size=_size, fill="rgb(255,255,255)"))

    _c = (40,0) # conceptual cursor
    dwg.add(dwg.image(os.path.join(args.plots_folder, "gwas", "PGC_scz2_qq.png"), _c, _1_size))
    _kot(dwg, _c, "a", ox=-20, oy=30)

    _c =_advance_cursor (_c, _1_size[1]+0, 0)
    dwg.add(dwg.image(os.path.join(args.plots_folder, "gwas", "PGC_scz2_significant_bars.png"), _c, _1_size))
    _kot(dwg, _c, "b", ox=-20, oy=30)

    _c = (40+math.ceil(_1_size[0]-_2_size[0])/2.0,_1_size[1]+40) # conceptual cursor
    dwg.add(dwg.image(os.path.join(args.input_folder_2, "stissuexcan_illustration_2.png"), _c, _1_size))
    _kot(dwg, _c, "c", ox=-20, oy=30)

    _c =_advance_cursor (_c, _1_size[0]+40, 0)
    dwg.add(dwg.image(os.path.join(args.plots_folder, "gwas", "smt_only_vs_sp_only_number_significant.png"), _c, _1_size))
    _kot(dwg, _c, "d", ox=-20, oy=30)

    dwg.save()
    t = os.path.join(args.output_folder, "fig-gwas-smt-vs-sp.png")
    to_png(_p, t)
    os.remove(_p)

def shove(args):
    def _shove(input_folder, output_folder, files, file_prefix=""):
        for sf in files:
            shutil.copy(os.path.join(input_folder, *sf),
                        os.path.join(output_folder, file_prefix + sf[len(sf) - 1].replace("_", "-")))

    figures = [("ukb","smt_vs_mt_ukb.png",)]
    _shove(args.plots_folder, args.output_folder, figures, file_prefix="fig-")

    supp_figures = [("ukb", "smt_vs_mt_ukb_supp.png",),]
    _shove(args.plots_folder, args.output_folder, supp_figures, "supp-fig-")

    supp_data =[("gwas_traits.txt",),
                ("gwas_stissuexcan_stats.txt",),
                ("gwas_stissuexcan_significant.txt",),
                ("gwas_sp_significant.txt",),
                ("ukb_tissuexcan_stats.txt",),
                ("ukb_p_significant.txt",),
                ("ukb_tissuexcan_significant.txt",)]
    _shove(args.input_folder, args.output_folder, supp_data, "supp-data-")

########################################################################################################################
def run(args):
    if not os.path.exists(args.output_folder):
        os.makedirs(args.output_folder)

    shove(args)
    figure_1(args)
    figure_2(args)
    #figure_4(args)

if __name__ == "__main__":
    class Dummy(object):
        def __init__(self):
            self.output_folder = "results/paper_material"
            self.plots_folder = "results/plots"
            self.input_folder = "results"
            self.input_folder_2 = "images"

    args = Dummy()
    run(args)
