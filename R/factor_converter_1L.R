factor_converter_1L <- function(f){
  # conversion for character data
  if (is.na(as.numeric(levels(f)))){
    as.character(levels(f))
    # conversion for numeric data
  } else {
    as.numeric(levels(f))
  }
}
