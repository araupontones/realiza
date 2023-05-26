#clean list names
clean_zoho_list <- function(x){
  
  ifelse(stringr::str_detect(x,"list"),
         stringr::str_extract(x, '(?<=display_value = ").*?(?=", ID)'),
         x)
}


