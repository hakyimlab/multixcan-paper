def figure_3_(args):
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

def figure_4_(args):
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
