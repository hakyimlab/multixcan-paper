p_save_delim <- function(data, path){
  write.table(data, file=path, row.names = FALSE, sep="\t", quote=FALSE)
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


textify <- function(text) {
  text <- gsub("_", " ",text)
  text
}