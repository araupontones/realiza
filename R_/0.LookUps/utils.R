library(stringr)
#'Utils lookup
#'

#' get value from variables formatted as lists in Zoho ===========================

clean_zoho_lisr <- function(x){
  
  ifelse(stringr::str_detect(x,"list"),
         stringr::str_extract(x, '(?<=display_value = ").*?(?=", ID)'),
         x)
}


