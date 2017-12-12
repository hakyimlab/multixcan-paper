p_save_delim <- function(data, path){
  write.table(data, file=path, row.names = FALSE, sep="\t", quote=FALSE)
}

textify <- function(text) {
  text <- gsub("_", " ",text)
  text
}