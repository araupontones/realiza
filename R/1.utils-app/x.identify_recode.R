#'@description return a recode of these vectores are created in R/vectors_fnm.R 
#'and vectors_sgr.R
#'@param id contains either modulos or sessoes (modulos is SGR, sessoes is FNM)

identify_recode <- function(id){
  
  if(str_detect(id, "modulos")){
    
    my_vector <-  recode_sgr
    
  } else if(str_detect(id, "sessoes")){
    
    my_vector <- recode_fnm
  } else {
    
    my_vector <-  ""
  }
  
  return(my_vector)
  
  
}