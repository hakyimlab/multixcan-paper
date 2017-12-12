
paper_plot_theme_a <- function() {
  ggplot2::theme_bw() +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust=0.5, face="bold", size=27),
                 plot.subtitle = ggplot2::element_text(hjust=0.5, face="italic", size=25),
                 axis.title = ggplot2::element_text(size=25),
                 axis.text = ggplot2::element_text(size=20),
                 legend.text = ggplot2::element_text(size = 15)) + 
  ggplot2::theme(legend.position="bottom",legend.direction="horizontal")
}

save_png <- function(plot, path, height, width, res=NA) {
  png(path, height=height, width=width, res=res)
  print(plot)
  dev.off()
}

save_svg <- function(plot, path, height, width) {
  svg(path, height=height, width=width)
  print(plot)
  dev.off()
}
