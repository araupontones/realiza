#'@description identifies whether the section is for modules or for sessoes

identify_mode <- function(id ){
  
  if(str_detect(id, "modulo")){
    
    mode = "modulos"
  
  } else {
      
    modulo = "sessoes"
    } 
  
  
}